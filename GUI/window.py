from utils.Event import subscribe, post_event
from PySide2.QtCore import QObject, Slot, Signal, QTimer
import serial.tools.list_ports

from utils.settings import GetSettingsManager
from utils.script import GetScriptsManager

class MainWindow(QObject):
    # Signáli pro získání nastavení tiskárny
    getPorts = Signal(list)
    getBaudrates = Signal(list)

    getPort = Signal(str)
    getBaudrate = Signal(int)

    getNumOfExtruders = Signal(int)

    getBedStatus = Signal(bool)
    getChamberStatus = Signal(bool)

    getExtruderMaxTemperature = Signal(list)
    getBedMaxTemperature = Signal(int)
    getChamberMaxTemperature = Signal(int)

    getExtruderTemperature = Signal(list)
    getBedTemperature = Signal(float)
    getChamberTemperature = Signal(float)

    getExtruderTargetTemperature = Signal(list)
    getBedTargetTemperature = Signal(float)
    getChamberTargetTemperature = Signal(float)

    getPositions = Signal(list)

    getPrinterStatus = Signal(bool)

    getPrinter_temp_interval = Signal(int)
    getPrinter_position_interval = Signal(int)

    getScriptList = Signal(list)
    getScriptText = Signal(str)

    # Signáli pro získání nastavení mqtt
    getMQTTIP = Signal(str)
    getMQTTPort = Signal(int)
    getMQTT_status = Signal(bool)
    getMQTT_auto_connect = Signal(bool)

    # Signáli pro získání nastavení MES
    getMESIP = Signal(str)
    getMESPort = Signal(int)

    getRemovalDialog = Signal(bool)

    extruder_target_temperature: list = [0]
    bed_target_temperature: float = 0
    chamber_target_temperature: float = 0

    def __init__(self):
        QObject.__init__(self)

        self.oldPort = None
        self.timer = QTimer()
        self.timer.timeout.connect(lambda: self.updatePort())
        self.timer.start(2000)

        self.settings = GetSettingsManager()
        self.scripts = GetScriptsManager()
        subscribe("temperature_update", self.update_temperature)
        subscribe("position_update", self.update_position)
        subscribe("printer_connection", self.update_printer_status)
        subscribe("MQTT_connection_status", self.mqtt_connection_state)
        subscribe("GUI_removal_dialog", self.RemovalDialog)

    @Slot()
    def Debug(self):
        print("!!DEBUG!!")

    @Slot()
    def Init(self):
        """Inicializační funkce pro předání nastavení applikace do QML souboru."""
        self.getPort.emit(self.settings.setting["serial"]["port"])
        self.getBaudrate.emit(self.settings.setting["serial"]["baudrate"])

        self.updatePort()
        self.getBaudrates.emit(self.settings.setting["GUI"]["baudrates"])

        self.getMQTTIP.emit(self.settings.setting["MQTT"]["IP_address"])
        self.getMQTTPort.emit(self.settings.setting["MQTT"]["port"])
        self.getMQTT_auto_connect.emit(self.settings.setting["MQTT"]["auto_connect"])

        self.getExtruderMaxTemperature.emit(self.settings.setting["printer"]["extruder"]["max_temp"])
        self.getBedMaxTemperature.emit(self.settings.setting["printer"]["bed"]["max_temp"])
        self.getChamberMaxTemperature.emit(self.settings.setting["printer"]["chamber"]["max_temp"])

        self.getScriptList.emit(self.scripts.get_list_of_scripts())

    def updatePort(self):
        """
        Funkce pro updatování listu portu.
        :return:
        """
        ports = serial.tools.list_ports.comports()
        f_ports = []
        for port, dest, hwid in sorted(ports):
            f_ports.append(port)

        if self.oldPort == f_ports:
            pass
        else:
            self.getPorts.emit(f_ports)
            self.oldPort = f_ports

    def update_temperature(self, data):
        #todo: při posílání teploty extruderu rozdělit cílovou a reálnou
        self.getExtruderTemperature.emit(data["tools"])
        self.getBedTemperature.emit(data["bed"][0])
        self.getChamberTemperature.emit(data["chamber"][0])

        if data["tools"][1] != self.extruder_target_temperature[0]:
            self.extruder_target_temperature[0] = data["tools"][1]
            self.getExtruderTargetTemperature.emit(self.extruder_target_temperature)
        if data["bed"][1] != self.bed_target_temperature:
            self.bed_target_temperature = data["bed"][1]
            self.getBedTargetTemperature.emit(self.bed_target_temperature)
        if data["chamber"][1] != self.chamber_target_temperature:
            self.chamber_target_temperature = data["chamber"][1]
            self.getChamberTargetTemperature.emit(self.chamber_target_temperature)

    def update_position(self, data):
        try:
            position_list = [data["X"], data["Y"], data["Z"]]
            self.getPositions.emit(position_list)
        except KeyError:
            print("Nejsou zde data")

    @Slot(str, int)
    def send_move_command(self, axis, range):
        command = {"axis": axis,
                   "range": range
                   }
        post_event("printer_command_axis", command)

    @Slot(str)
    def getScript(self, name):
        script = self.scripts.get_script(name)
        print(script)
        self.getScriptText.emit(script)

    @Slot(str, str)
    def saveScript(self, name, g_code):
        self.scripts.update_script(name, g_code)
        print(f"name {name}, script {g_code}")

    @Slot(str)
    def send_home_command(self, axis):
        command = {"axis": axis,
                   }
        post_event("printer_command_home", command)

    @Slot(str, int)
    def send_temp_command(self, tool, value):
        command = {"tool": tool,
                   "value": value,
                   }
        print(command)
        post_event("printer_command_temp", command)

    @Slot()
    def print_connect(self):
        post_event("printer_connect", None)

    @Slot()
    def print_disconnect(self):
        post_event("printer_disconnect", None)

    def update_printer_status(self, status: str):
        if status == "CONNECTED":
            self.getPrinterStatus.emit(True)
        elif status == "DISCONNECTED":
            self.getPrinterStatus.emit(False)
        else:
            print("Neznamý stav")
    # komunikace GUI s nastavením tiskárny

    @Slot(str)
    def serial_change_port(self, port: str):
        post_event("serial_settings", {"port": port})
        print(f"port: {port}")

    @Slot(int)
    def serial_change_baudrate(self, baudrate: int):
        post_event("serial_settings", {"baudrate": baudrate})
        print(f"baudrate: {baudrate}")

    @Slot(int)
    def printer_change_num_of_extruders(self, num_of_extruder: int):
        pass

    @Slot(int)
    def printer_change_temp_interval_report(self, interval: int):
        post_event("printer_set_interval", {"type": "temperature", "interval": interval})

    @Slot(int)
    def printer_change_position_interval_report(self, interval: int):
        post_event("printer_set_interval", {"type": "position", "interval": interval})

    # komunikace GUI s MQTT modulem
    @Slot(str)
    def mqtt_change_ip(self, ip_address: str):
        data = {"ip_address": ip_address}
        post_event("MQTT_settings", data)

    @Slot(str)
    def mqtt_change_port(self, port: int):
        data = {"port": port}
        post_event("MQTT_settings", data)

    @Slot()
    def mqtt_connect(self):
        post_event("MQTT_connection", True)

    @Slot()
    def mqtt_disconnect(self):
        post_event("MQTT_connection", False)

    @Slot(bool)
    def mqtt_auto_connect(self, state: bool):
        data = {"auto_connect": state}
        post_event("MQTT_settings", data)

    def mqtt_connection_state(self, state: bool):
        self.getMQTT_status.emit(state)

    @Slot(str)
    def print(self, file_url: str):
        print(f"Start print {file_url}")
        post_event("printer_start_print", file_url)

    @Slot()
    def RemovalDone(self):
        post_event("system_state", "removed")

    def RemovalDialog(self):
        self.getRemovalDialog.emit(True)

#todo: přidat posílání do fronty

    @Slot(int)
    def fan_rate_change(self, value):
        print(f"fan_rate: {value}")

    @Slot(int)
    def flow_rate_change(self, value):
        print(f"flow_rate: {value}")

    @Slot(bool)
    def motor_state_change(self, state):
        print(f"motor_state: {state}")
