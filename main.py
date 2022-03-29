import os
from pathlib import Path
import sys

from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import QObject, Slot, Signal, QTimer
from PySide6.QtQuickControls2 import QQuickStyle

from printer.communicatio import Printer

from GUI.window import MainWindow

from utils.MQTT import MQTT

if __name__ == "__main__":
    QQuickStyle.setStyle("Material")
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    # Context
    main = MainWindow()
    engine.rootContext().setContextProperty("backend", main)

    engine.load(os.fspath(Path(__file__).resolve().parent / "GUI/content/App.qml"))
    if not engine.rootObjects():
        sys.exit(-1)

    mqtt = MQTT()
    printer = Printer(port='COM4', baudrate=250000)
    sys.exit(app.exec())