import os
from pathlib import Path
import sys

from PySide2.QtGui import QGuiApplication
from PySide2.QtQml import QQmlApplicationEngine
from PySide2.QtQuickControls2 import QQuickStyle

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
    printer = Printer()
    sys.exit(app.exec_())
