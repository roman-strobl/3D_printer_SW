import unittest

from printer.messages import G_Command_with_line, G_Command_without_line

COMMAND: str = "G1 X25"
N: int = 1


class TestMessages_with_line(unittest.TestCase):

    def setUp(self) -> None:
        self.command = G_Command_with_line(COMMAND, N)

    def test_isByte(self):
        self.assertEqual(bytes, type(self.command.process()), "Výstup není typu bytes")

    def test_correct_checksum(self):
        self.assertEqual(b"N1 G1 X25*86\n", self.command.process(), "Výstup není zprávný")

class TestMessages_without_line(unittest.TestCase):

    def setUp(self) -> None:
        self.command = G_Command_without_line(COMMAND)

    def test_isByte(self):
        self.assertEqual(bytes, type(self.command.process()), "Výstup není typu bytes")

    def test_correct_checksum(self):
        self.assertEqual(b"G1 X25\n", self.command.process(), "Výstup není zprávný")


if __name__ == '__main__':
    unittest.main()