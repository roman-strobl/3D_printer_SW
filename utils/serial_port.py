from dataclasses import dataclass
from typing import Optional

import serial.tools.list_ports

@dataclass
class SerialPort(object):
    """Class for serializing a list of ports"""

    port: str
    dest: Optional[str]
    hwid: Optional[str]

    def serialize(self) -> dict:
        serialized = {
            "port": f"{self.port}", "dest": f"{self.dest}", "hwid": f"{self.hwid}"}
        return serialized

@dataclass
class Serialports(object):

    ports: list[SerialPort]

    def get_ports(self) -> None:
        ports = serial.tools.list_ports.comports()

        self.ports = []

        for port, dest, hwid in sorted(ports):
            self.ports.append(SerialPort(port=port, dest=dest, hwid=hwid))

