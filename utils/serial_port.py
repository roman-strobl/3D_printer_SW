from dataclasses import dataclass
from typing import Optional


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





