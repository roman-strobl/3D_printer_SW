import serial
import re
import time
import json
import threading
import queue
import logging

from printer.messages import G_Command_with_line, G_Command_without_line

regex_temp = re.compile(
    r"(?P<tool>B|C|T(?P<toolnum>\d*)):\s*(?P<actual>[-+]?\d*\.?\d+)\s*\/?\s*(?P<target>[-+]?\d*\.?\d+)?")
regex_position = re.compile(
    r"(?P<axis>X|Y|Z):\s*(?P<value>[-+]?\d*\.?\d+)?")
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

        self._dimension_X = 235
        self._dimension_Y = 235
        self._dimension_Z = 240

        self._sending_from_file = False
        self._command_sended = False

        self._pause = False

        self._command_to_send = queue.Queue(100)

        self._sending_active = True
        self.sending_thread = threading.Thread(target=self._sender, name="comm._sender")
        self.sending_thread.daemon = False

        self.condition = threading.Condition()

        self._monitoring_active = True
        self.monitoring_thread = threading.Thread(target=self._monitoring, name="comm._monitor")
        self.monitoring_thread.daemon = False

        self._comm = serial.Serial(write_timeout=1, timeout=0.5)
        self._comm.setPort(kwargs.get("port"))
        self._comm.baudrate = kwargs.get("baudrate")

        self._autoreport_position = False
        self._autoreport_temp = False

        self.monitoring_thread.start()
        self.sending_thread.start()

    def connect(self) -> str:
        try:
            self._comm.open()
            time.sleep(1)
        except Exception as ex:
            return str(ex)
        time.sleep(2)

        self._command_to_send.put("M110")
        self._command_to_send.put("M115")

        return "connected"

    def disconnect(self) -> str:

        self._comm.close()

        return "disconnect"

    def _reader(self):
        if self._comm is None:
            return None

        try:
            string = self._comm.readline()
        except Exception as ex:
            print(f"Naskytla se chyba {ex}")
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
            print(message)

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
                    self.condition.notifyAll()
                print("Ready")
                continue

            if "T:" in message or "T0:" in message or "B:" in message or "C:" in message:

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

        return

    def _sender(self):
        n_line = 1
        while self._sending_active:

            if not self._pause:
                try:
                    command = self._command_to_send.get()
                except queue.Empty:
                    continue
                try:
                    command_to_send = G_Command_with_line(command, n_line)
                    self._comm.write(command_to_send.process())
                    self._comm.flush()
                    print(f"Poslaný příkaz {command_to_send}")
                    n_line += 1
                finally:
                    self._command_to_send.task_done()
            with self.condition:
                self.condition.wait()
        return "konec"

    pass

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

if __name__ == '__main__':
    # printer = Printer(port='/dev/ttyACM0', baudrate=250000)
    printer = Printer(port='COM6', baudrate=250000)
    printer.connect()
