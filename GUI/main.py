import os
from pathlib import Path
import sys

from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import QObject, Slot, Signal, QTimer

import serial.tools.list_ports

from printer.communicatio import Printer
from utils.Event import subscribe, post_event

class MainWindow(QObject):

    getPort = Signal(list)
    getBaudrate = Signal(list)
    getTemperature = Signal(dict)


    def __init__(self):
        QObject.__init__(self)

        self.oldPort = None
        self.timer = QTimer()
        self.timer.timeout.connect(lambda: self.updatePort())
        self.timer.start(2000)

        subscribe("temperature_update", self.update_temperature)

    @Slot(str)
    def portList(self, text):
        print(text)

    @Slot()
    def initPort(self):
        ports = serial.tools.list_ports.comports()
        f_ports = []
        for port, dest, hwid in sorted(ports):
            f_ports.append(port)

        self.getPort.emit(f_ports)

    @Slot()
    def Debug(self):
        print("!!DEBUG!!")

    @Slot()
    def Init(self):
        Baudrate = [115200, 250000, 230400, 57600, 38400, 19200, 9600]
        self.getBaudrate.emit(Baudrate)

    def updatePort(self):
        ports = serial.tools.list_ports.comports()
        f_ports = []
        for port in sorted(ports):
            f_ports.append(port)

        if self.oldPort == f_ports:
            return
        else:
            self.getPort.emit(f_ports)
            self.oldPort = f_ports
            return

    def update_temperature(self, data):
        print(data)

    @Slot()
    def print_connect(self):
        post_event("printer-connection", "connect")




if __name__ == "__main__":
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    # Context
    main = MainWindow()
    engine.rootContext().setContextProperty("backend", main)

    engine.load(os.fspath(Path(__file__).resolve().parent / "content/App.qml"))
    if not engine.rootObjects():
        sys.exit(-1)

    #printer = Printer(port='COM5', baudrate=250000)
    #printer.connect()

    sys.exit(app.exec())
