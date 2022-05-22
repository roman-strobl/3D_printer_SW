import datetime
import io

import serial
import re
import time
import threading
import queue

import logging

from printer.messages import G_Command_with_line, decommenter

from utils.Event import fire_event, subscribe

from utils.settings import GetSettingsManager
from utils.script import GetScriptsManager

regex_temp = re.compile(
    r"(?P<tool>B|C|T(?P<toolnum>\d*)):\s*(?P<actual>[-+]?\d*\.?\d+)\s*\/?\s*(?P<target>[-+]?\d*\.?\d+)?")
regex_position = re.compile(
    r"(?P<axis>X|Y|Z|E):\s*(?P<value>[-+]?\d*\.?\d+)?")
regex_Firmware = re.compile(
    r"([A-Z][A-Z0-9_]*):")
regex_cap = re.compile(
    r"(?P<name>\w*):(?P<value>[01])")


class PrinterState(object):
    IDLE = "idle"
    PRINTING = "printing"
    REMOVAL = "removal"
    PAUSE = "pause"


class Printer(object):
    """
    Class for create instance of printer, which controls printing.
    """

    def __init__(self, *args, **kwargs) -> None:
        """
        Inicialite the class of printer.
        """
        self._is_loading = None
        self.settings = GetSettingsManager()
        self.scripts = GetScriptsManager()

        self._extruder_count = 1

        self._temp: list = [0]
        self._bedTemp: int = 0
        self._chamberTemp: int = 0

        self._targetTemp: list = [0]
        self._targetBedTemp: int = 0
        self._targetChamberTemp: int = 0

        self._targetTemp_pause: list = [0]
        self._targetBedTemp_pause: int = 0
        self._targetChamberTemp_pause: int = 0

        self._print_param = {}

        self._state = PrinterState.IDLE
        self._M115_state = False

        self._logger = logging.getLogger(__name__)
        self._comm = None

        self._automatic_send_temp = False

        self._printing = False

        self._position_X = 0.0
        self._position_Y = 0.0
        self._position_Z = 0.0

        self._dimension_X = 235
        self._dimension_Y = 235
        self._dimension_Z = 240

        self._sending_from_file = False
        self._command_sended = False

        self._pause = False

        self._command_to_send = queue.Queue()
        self._command_to_send_priority = queue.Queue()

        self._sending_active = False
        self._monitoring_active = False
        self.sending_thread = None
        self.monitoring_thread = None

        self.event = threading.Event()

        self._comm = serial.Serial(timeout=0.5)
        self._comm.setPort(self.settings.setting["serial"]["port"])
        self._comm.baudrate = self.settings.setting["serial"]["baudrate"]

        self._auto_connect = self.settings.setting["serial"]["auto_connect"]

        self._autoreport_position = False
        self._autoreport_temp = False

        subscribe("printer_connect", self.connect)
        subscribe("printer_disconnect", self.disconnect)
        subscribe("printer_command", self.command_from_GUI)
        subscribe("printer_command_axis", self.command_move_event)
        subscribe("printer_command_home", self.command_home_event)
        subscribe("printer_command_temp", self.command_temp_event)
        subscribe("printer_start_print", self.print_from_file_buffered)
        subscribe("serial_settings", self.serial_change)
        subscribe("printer_set_interval", self.report_interval)
        subscribe("printer_auto_removal", self.automatically_remove)
        subscribe("printer_printing_handle", self.printing_handle)

        if self._auto_connect is True:
            self.connect()

    def _start_threads(self) -> None:
        """Metoda pro zapnutí vláken pro monitoring a posílání"""

        self._sending_active = True
        self._monitoring_active = True

        self.sending_thread = threading.Thread(target=self._sender, name="comm._sender")
        self.monitoring_thread = threading.Thread(target=self._monitoring, name="comm._monitor")

        self.sending_thread.daemon = True
        self.monitoring_thread.daemon = True

        self.monitoring_thread.start()
        self.sending_thread.start()

    def connect(self) -> None:
        """Metoda pro otevření komunikace"""
        try:
            self._comm.open()
            time.sleep(1)
        except Exception as ex:
            fire_event("Serial_ERROR", "Failed to open serial communication")
            print(ex)
            return
        self._start_threads()
        time.sleep(2)
        self.put_command("M110")
        self.put_command("M115")
        fire_event("printer_connection", "CONNECTED")

    def disconnect(self) -> str:
        """Metoda pro uzavření komunikace"""
        self._sending_active = False
        self._monitoring_active = False

        self.sending_thread = None
        self.monitoring_thread = None

        self._command_to_send = queue.Queue()
        self._command_to_send_priority = queue.Queue()

        self._comm.close()
        fire_event("printer_connection", "DISCONNECTED")
        return "disconnect"

    def printing_handle(self, command):
        if command == "stop":
            self.print_stop()
        elif command == "pause":
            self.print_pause()
        elif command == "unpause":
            self.print_unpause()

    def print_stop(self):
        """Metoda pro vypnutí tisku"""
        self._command_to_send = queue.Queue()
        self._state = PrinterState.IDLE
        self._command_to_send_priority.put("M204")
        self._command_to_send_priority.put("M140 S0")
        if self._extruder_count > 1:
            for i in range(self._extruder_count-1):
                self._command_to_send_priority.put(f"M104 T{i} S0")
        else:
            self._command_to_send_priority.put(f"M104 T S0")
        self.add_script_to_queue("on_stop", priority=True)
        fire_event("printer_state", self._state)
        fire_event("system_state", "stopped")

    def print_pause(self):
        """Metoda na pozastavení tisku"""
        if self._state == PrinterState.PRINTING:
            self._pause = True
            self._state = PrinterState.PAUSE
            self.add_script_to_queue("on_pause", priority=True)
            fire_event("printer_state", self._state)

    def print_unpause(self):
        """Metoda pro obnovu tisku"""
        if self._state == PrinterState.PAUSE:
            self._pause = False
            self._state = PrinterState.PRINTING
            self._command_to_send_priority.put("unpause")
            fire_event("printer_state", self._state)

    def command_from_GUI(self, command):
        self.put_command(command)

    def command_move_event(self, command: dict):

        if command["axis"] == "X":
            self._position_X += command["range"]
            self.put_command(f"G1 X{self._position_X}")
        if command["axis"] == "Y":
            self._position_Y += command["range"]
            self.put_command(f"G1 Y{self._position_Y}")
        if command["axis"] == "Z":
            self._position_Z += command["range"]
            self.put_command(f"G1 Z{self._position_Z}")
        print(command)

    def command_home_event(self, command: dict):
        if command['axis'] == "all":
            self.put_command(f"G28")
        else:
            self.put_command(f"G28 {command['axis']}")

    def command_temp_event(self, command: dict):
        if "T" in command["tool"]:
            self.put_command(f"M104 S{command['value']}")
        if command["tool"] == "B":
            self.put_command(f"M140 S{command['value']}")
        if command["tool"] == "C":
            self.put_command(f"M141 S{command['value']}")

    def serial_change(self, data: dict):
        if data.get("port"):
            self._comm.setPort(data["port"])
            self.settings.setting["serial"]["port"] = data["port"]
            self.settings.update()

        if data.get("baudrate"):
            self._comm.baudrate = data["baudrate"]
            self.settings.setting["serial"]["baudrate"] = data["baudrate"]
            self.settings.update()

    def report_interval(self, data: dict):
        if data["type"] == "temperature":
            self._set_autoreport_temp(data.get("interval"))
            self.settings.setting["printer"]["temperature_report_interval"] = data.get("interval")
            self.settings.update()

        if data["type"] == "position":
            self._set_autoreport_position(data.get("interval"))
            self.settings.setting["printer"]["position_report_interval"] = data.get("interval")
            self.settings.update()

    def _reader(self):
        """Metoda pro čtení řádku v bufferu tiskárny"""
        if self._comm is None:
            return None

        try:
            string = self._comm.readline()
        except Exception as ex:
            fire_event("Serial_ERROR", "There is a problem with serial communication")
            print(f"Naskytla se chyba {ex}")
            self.disconnect()

            return None

        string = string.decode('utf-8')

        return string

    def _monitoring(self):
        """Metoda pro čtení bufferu tiskárny"""
        while self._monitoring_active:

            message = self._reader()

            if message is None:
                break
            elif message == "":
                time.sleep(0.001)
                continue
            logging.debug(f"Message arrived: {message}")
            print(message)
            if self._M115_state:
                #zpracovávání dat o firmwaru tiskárny
                if not message.startswith("Cap") and not message.startswith("cap"):
                    self._M115_state = False

                    if self._print_param.get("AUTOREPORT_TEMP") == "1":
                        self._set_autoreport_temp(self.settings.setting["printer"]["temperature_report_interval"])

                    if self._print_param.get("AUTOREPORT_POS") == "1":
                        self._set_autoreport_position(self.settings.setting["printer"]["position_report_interval"])

                    if self._print_param.get("EXTRUDER_COUNT") == "1":
                        self._extruder_count = int(self._print_param["EXTRUDER_COUNT"])
                        for i in range(self._extruder_count-1):
                            self._temp.append(0)
                            self._targetTemp.append(0)
                    print(self._print_param)
                    print(self._M115_state)

            #print(message)
            if message.startswith("resend:"):
                # Toto zpracování není nutné, protože komunikace funguje na principu ping-pong komunikace
                continue

            if message.startswith("ok") or message.startswith(" ok"):
                # Handlování odpovědi OK z tiskárny
                self.event.set()
                if not ("X:" in message or " Y:" in message or " Z:" in message or " E:" in message) and not (
                        " T:" in message or " T0:" in message or " B:" in message or " C:" in message):
                    continue

            if message.startswith("X:") or " Y:" in message or " Z:" in message or " E:" in message:
                # zpracování pozice tiskárny
                string = message.split("Count")
                data = {}
                for match in re.finditer(regex_position, string[0]):

                    data[match["axis"]] = match["value"]
                fire_event("position_update", data)
                continue

            if " T:" in message or " T0:" in message or " B:" in message or " C:" in message:
                # zpracování teploty tiskárny
                result = {}

                for match in re.finditer(regex_temp, message):

                    values = match.groupdict()

                    tool = values["tool"]

                    try:
                        actual = float(match.group(3))
                        target = None
                        if match.group(4):
                            target = float(match.group(4))

                        result[tool] = (actual, target)
                    except ValueError:
                        print("Vyskytla se chyba")
                if self._extruder_count == 1:
                    if "T" in result:
                        self._temp[0], self._targetTemp[0] = result["T"]
                    elif "T0" in result:
                        self._temp[0], self._targetTemp[0] = result["T0"]
                else:
                    if "T" in result:
                        self._temp[0], self._targetTemp[0] = result["T"]
                    for i in range(self._extruder_count-1):
                        if f"T{i}" in result:
                            self._temp[i+1], self._targetTemp[i+1] = result["T"]

                if "B" in result:
                    self._bedTemp, self._targetBedTemp = result["B"]

                if "C" in result:
                    self._chamberTemp, self._targetChamberTemp = result["C"]

                data = {"time": datetime.datetime.now().ctime(),
                        "tools": [self._temp, self._targetTemp],
                        "bed": [self._bedTemp, self._targetBedTemp],
                        "chamber": [self._chamberTemp, self._targetChamberTemp],
                        }
                # self.client.publish("printer/temperature", str(data))
                fire_event("temperature_update", data)
                continue

            if message.startswith("FIRMWARE_NAME:"):
                self._M115_state = True
                match = re.finditer(regex_Firmware, message)
                position = list()
                for k in match:
                    position.append(message.find(k.group()))

                for k in range(len(position)):
                    if k < len(position) - 1:
                        name, value = message[position[k]:position[k + 1] - 1].split(":", 1)
                        self._print_param[str(name)] = value

                    else:
                        name, value = message[position[k]:-1].split(":", 1)
                        self._print_param[str(name)] = value

            if message.startswith("Cap") or message.startswith("cap"):
                match = re.search(regex_cap, message)
                self._print_param[match["name"]] = match["value"]

        self.event.set()
        return

    def _sender(self):
        #Metoda pro posílání příkazů
        n_line = 1
        while self._sending_active:
            if self._sending_active and not self._is_loading:
                try:
                    # Neprve získání příkazu z prioritní fronty
                    command = self._command_to_send_priority.get(block=(self._state != PrinterState.PRINTING))
                except queue.Empty:
                    if not self._pause:
                        try:
                            # získání příkazu z neprioritní fronty, který slouži pro uložení G-kódu pro tisk
                            command = self._command_to_send.get(block=False)
                        except queue.Empty:
                            time.sleep(0.01)
                            continue
                    else:
                        time.sleep(0.01)
                        continue

                try:
                    #zaznamenání startu tisku
                    if command == "start":
                        self._state = PrinterState.PRINTING
                        print("Startujeme")
                        fire_event("printer_state", self._state)
                        continue

                    # zaznamenání konce tisku
                    if command == "done":
                        self._state = PrinterState.IDLE
                        fire_event("system_state", "done")
                        fire_event("printer_state", self._state)
                        continue

                    # zaznamenání konce pauzi, je zde kvůli tomu, aby se tisk rozjel.
                    if command == "unpause":
                        continue

                    # zaznamenání automatického odstranění objektu z tiskové plochy
                    if command == "removed":
                        self._state = PrinterState.IDLE
                        fire_event("system_state", "removed")
                        fire_event("printer_state", self._state)
                        continue

                    command_to_send = G_Command_with_line(command, n_line)
                    self.event.clear()
                    self._comm.write(command_to_send.process())
                    self._comm.flush()
                    print(f"Poslaný příkaz {command_to_send}")
                    logging.debug(f"Message send: {command_to_send}")
                    n_line += 1

                except Exception as ex:
                    fire_event("Serial_ERROR", "There is a problem with serial communication")
                    print(f"Naskytla se chyba {ex}")
                    self.disconnect()

                self.event.wait()

    @property
    def port(self):
        return self._comm.port

    @port.setter
    def port(self, port):
        self._comm.setPort(port)

    @property
    def baudrate(self):
        return self._comm.baudrate

    @baudrate.setter
    def baudrate(self, baudrate):
        self._comm.baudrate = int(baudrate)

    def _set_autoreport_temp(self, interval: int = 4):
        command = f"M155 S{interval}"
        self.put_command(command)
        self._autoreport_temp = True

    def _set_autoreport_position(self, interval: int = 1):
        command = f"M154 S{interval}"
        self.put_command(command)
        self._autoreport_position = True

    def put_command(self, command: str):
        self._command_to_send_priority.put(command)

    def is_connect(self):
        return self._comm.isOpen()

    def print_from_file_buffered(self, file: str):
        #metoda pro tisk ze souboru.
        self._is_loading = True
        try:
            f = open(file)
            print(f'soubor {file} se podařilo otevřít')
        except Exception as ex:
            print(ex)
            self._is_loading = False
            return

        self._command_to_send_priority.put("start")
        self.add_script_to_queue("start", empty_script=True)
        for line in f:
            f_line = line.strip()  # vymazání zbytečných mezer
            f_line = decommenter(f_line)
            if f_line.isspace() is False and len(f_line) > 0:
                self._command_to_send.put(f_line)
                #print(f"příkaz {f_line} byl přidát do fronty")

        f.close()
        self.add_script_to_queue("end", empty_script=True)
        self._command_to_send.put("done")
        self._is_loading = False
        print("G-kod nacten")

    def automatically_remove(self):
        self._state = PrinterState.REMOVAL
        self.add_script_to_queue("removal", "removed")

    def add_script_to_queue(self, name: str, indicator: str = None, empty_script: bool = False, priority: bool = False):
        self._is_loading = True
        script = self.scripts.get_script(name)
        if script == "":
            self._is_loading = empty_script
            return
        for line in script.split("\n"):
            f_line = line.strip()  # vymazání zbytečných mezer
            f_line = decommenter(f_line)
            if f_line.isspace() is False and len(f_line) > 0:
                if priority is False:
                    self._command_to_send.put(f_line)
                else:
                    self._command_to_send_priority.put(f_line)
        if indicator is not None:
            if priority is False:
                self._command_to_send.put(indicator)
            else:
                self._command_to_send_priority.put(indicator)
        self._is_loading = False


if __name__ == '__main__':
    # printer = Printer(port='/dev/ttyACM0', baudrate=250000)
    printer = Printer(port='COM5', baudrate=250000)
    printer.connect()
    #time.sleep(2)
    #printer.print_from_file("kostka.gcode")
