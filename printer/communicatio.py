import datetime

import serial
import re
import time
import threading
import queue


from printer.messages import G_Command_with_line, decommenter

from utils.Event import post_event, subscribe

from utils.settings import GetSettingsManager

regex_temp = re.compile(
    r"(?P<tool>B|C|T(?P<toolnum>\d*)):\s*(?P<actual>[-+]?\d*\.?\d+)\s*\/?\s*(?P<target>[-+]?\d*\.?\d+)?")
regex_position = re.compile(
    r"(?P<axis>X|Y|Z|E):\s*(?P<value>[-+]?\d*\.?\d+)?")
regex_Firmware = re.compile(
    r"([A-Z][A-Z0-9_]*):")
regex_cap = re.compile(
    r"(?P<name>\w*):(?P<value>[01])")


class Printer(object):
    """
    Class for create instance of printer, which controls printing.
    """

    def __init__(self, *args, **kwargs) -> None:
        """
        Inicialite the class of printer.
        """
        self.settings = GetSettingsManager()
        self._extruder_count = None

        self._temp: list = []
        self._bedTemp: int = 0
        self._chamberTemp: int = 0

        self._targetTemp: list = []
        self._targetBedTemp: int = 0
        self._targetChamberTemp: int = 0

        self._print_param = {}

        self._state = None
        self._M115_state = False

        self._comm = None

        self._automatic_send_temp = False

        self._position_X = 0.0
        self._position_Y = 0.0
        self._position_Z = 0.0

        #todo: zbytečné vědět, jak je tiskárná velká, protože se s tím vůbec nepracuje
        self._dimension_X = 235
        self._dimension_Y = 235
        self._dimension_Z = 240

        self._sending_from_file = False
        self._command_sended = False

        self._pause = False

        self._command_to_send = queue.Queue()

        self._sending_active = False
        self._monitoring_active = False
        self.sending_thread = None
        self.monitoring_thread = None

        self.condition = threading.Condition()

        self._comm = serial.Serial(write_timeout=1, timeout=0.5)
        self._comm.setPort(self.settings.setting["serial"]["port"])
        self._comm.baudrate = self.settings.setting["serial"]["baudrate"]

        self._autoreport_position = False
        self._autoreport_temp = False

        subscribe("printer_connect", self.connect)
        subscribe("printer_disconnect", self.disconnect)
        subscribe("printer_command_axis", self.command_move_event)
        subscribe("printer_command_home", self.command_home_event)
        subscribe("printer_command_temp", self.command_temp_event)
        subscribe("serial_settings", self.serial_change)
        subscribe("printer_set_interval", self.report_interval)

    def _start_threads(self) -> None:

        self._sending_active = True
        self._monitoring_active = True

        self.sending_thread = threading.Thread(target=self._sender, name="comm._sender")
        self.monitoring_thread = threading.Thread(target=self._monitoring, name="comm._monitor")

        self.sending_thread.daemon = True
        self.monitoring_thread.daemon = True

        self.monitoring_thread.start()
        self.sending_thread.start()

    def connect(self) -> str:
        try:
            self._comm.open()
            time.sleep(1)
        except Exception as ex:
            return str(ex)

        self._start_threads()

        time.sleep(2)

        self._command_to_send.put("M110")
        self._command_to_send.put("M115")

        post_event("printer_connection", "CONNECTED")
        print("connected")

    def disconnect(self) -> str:

        self._sending_active = False
        self._monitoring_active = False

        self.sending_thread = None
        self.monitoring_thread = None

        self._command_to_send = queue.Queue()

        self._comm.close()
        post_event("printer_connection", "DISCONNECTED")
        return "disconnect"

    def command_move_event(self, command: dict):

        # Tato část kódu nefunguje pro python verze < 3.10
        #match command["axis"]:
        #    case "X":
        #        self._position_X += command["range"]
        #        self.put_command(f"G1 X{self._position_X}")
        #    case "Y":
        #        self._position_Y += command["range"]
        #        self.put_command(f"G1 Y{self._position_Y}")
        #    case "Z":
        #        self._position_Z += command["range"]
        #        self.put_command(f"G1 Z{self._position_Z}")

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
        # Tato část kódu nefunguje pro python verze < 3.10
        #match command["tool"]:
        #    case "T":
        #        self.put_command(f"M104 S{command['value']}")
        #    case "B":
        #        self.put_command(f"M140 S{command['value']}")
        #    case "C":
        #        self.put_command(f"M141 S{command['value']}")
        if command["tool"] == "T":
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

        if data["type"] == "position":
            self._set_autoreport_position(data.get("interval"))

    def _reader(self):
        if self._comm is None:
            return None

        try:
            string = self._comm.readline()
        except Exception as ex:
            post_event("Serial_ERROR", ex)
            print(f"Naskytla se chyba {ex}")
            self.disconnect()

            return None

        string = string.decode('utf-8')

        return string

    def _monitoring(self):

        while self._monitoring_active:

            message = self._reader()

            if message is None:
                break
            elif message == "":
                time.sleep(0.001)
                continue
            #print(message)

            if self._M115_state:
                if not message.startswith("Cap") and not message.startswith("cap"):
                    self._M115_state = False

                    if self._print_param.get("AUTOREPORT_TEMP") == "1":
                        self._set_autoreport_temp()

                    if self._print_param.get("AUTOREPORT_POS") == "1":
                        self._set_autoreport_position()

                    print(self._print_param)
                    print(self._M115_state)

            if message.startswith("resend:"):
                continue

            if message.startswith("ok"):
                with self.condition:
                    self.condition.notify_all()
                continue

            if message.startswith("X:") or " Y:" in message or " Z:" in message or " E:" in message:
                string = message.split("Count")
                data = {}
                for match in re.finditer(regex_position, string[0]):

                    data[match["axis"]] = match["value"]
                #self.client.publish("printer/position", str(data))
                post_event("position_update", data)

            if " T:" in message or " T0:" in message or " B:" in message or " C:" in message:
                print(message)
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
                        pass

                if "T" in result:
                    self._temp, self._targetTemp = result["T"]

                elif "T0" in result:
                    self._temp, self._targetTemp = result["T0"]

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
                post_event("temperature_update", data)

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

        print("konec")
        with self.condition:
            self.condition.notify_all()
        return

    def _sender(self):
        n_line = 1
        while self._sending_active:
            if not self._pause and self._sending_active:
                try:
                    command = self._command_to_send.get()
                    command_to_send = G_Command_with_line(command, n_line)
                    self._comm.write(command_to_send.process())
                    self._comm.flush()
                    print(f"Poslaný příkaz {command_to_send}")
                    n_line += 1
                except queue.Empty:
                    continue
                except Exception as ex:
                    post_event("Serial_ERROR", ex)
                    print(f"Naskytla se chyba {ex}")
                    self.disconnect()
                finally:
                    self._command_to_send.task_done()
                with self.condition:
                    self.condition.wait()
            else:
                print("konec sender")

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
        self._command_to_send.put(command)
        self._autoreport_temp = True

    def _set_autoreport_position(self, interval: int = 1):
        command = f"M154 S{interval}"
        self._command_to_send.put(command)
        self._autoreport_position = True

    def put_command(self, command: str):
        self._command_to_send.put(command)

    def is_connect(self):
        return self._comm.isOpen()

    def print_from_file(self, file: str):

        try:
            f = open(file)
            print(f'soubor {file} se podařilo otevřít')
        except Exception as ex:
            print(ex)
            pass

        for line in f:
            f_line = line.strip()  # vymazání zbytečných mezer
            f_line = decommenter(f_line)
            if f_line.isspace() is False and len(f_line) > 0:
                self._command_to_send.put(f_line)
                print(f"příkaz {f_line} byl přidát do fronty")

        f.close()


if __name__ == '__main__':
    # printer = Printer(port='/dev/ttyACM0', baudrate=250000)
    printer = Printer(port='COM5', baudrate=250000)
    printer.connect()
    #time.sleep(2)
    #printer.print_from_file("kostka.gcode")
