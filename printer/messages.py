from dataclasses import dataclass
from utils.utils import string_checksum


@dataclass
class G_Command_with_line():
    """
    Class for G-code coammnds with line and checksum.
    """
    command: str
    n_lines: int

    def process(self) -> bytes:
        """
        Fuction that returns correct format of command for printer with line and checksum.

        :return: formated command in bytes
        """
        command = "N" + str(self.n_lines) + " " + self.command

        checksum = string_checksum(command)

        command += "*" + str(checksum) + "\n"

        return command.encode()

    def __str__(self):
        return "N" + str(self.n_lines) + " " + self.command


@dataclass
class G_Command_without_line():
    """
    Class for G-code coammnds with line and checksum.
    """
    command: str

    def process(self) -> bytes:
        """
         Fuction that returns correct format of command for printer without line and checksum.

        :return: formated command in bytes
        """
        command = self.command + "\n"

        return command.encode()

    def __str__(self):
        return self.command






