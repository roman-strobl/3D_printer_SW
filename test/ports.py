from dataclasses import dataclass
import serial.tools.list_ports
ports = serial.tools.list_ports.comports()
print(f"Typ je: {type(ports)}")
print(ports)
for port, desc, hwid in sorted(ports):
        print("{}: {} [{}]".format(port, desc, hwid))





