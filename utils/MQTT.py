
import paho.mqtt.client as paho
from utils.settings import GetSettingsManager
from utils.Event import subscribe, post_event


def on_disconnect(client, userdata, rc):
    if rc != 0:
        print("Unexpected disconnection.")
    print("Disconnect")
    post_event("MQTT_connection_status", False)


def on_connect(client, userdata, flags, rc):
    if rc == 0:
        print("MQTT připojeno")
        post_event("MQTT_connection_status", True)
    else:
        print("MQTT nepřipojeno")


class MQTT(object):

    def __init__(self):
        self.settings = GetSettingsManager()
        self.IP_address = self.settings.setting["MQTT"]["IP_address"]
        self.port = self.settings.setting["MQTT"]["port"]
        self.printer_name = self.settings.setting["MQTT"]["name"]
        self.client = paho.Client("printer")
        self.client.on_connect = on_connect
        self.client.on_disconnect = on_disconnect
        self.auto_connect = self.settings.setting["MQTT"]["auto_connect"]

        subscribe("temperature_update", self.send_temperature)
        subscribe("position_update", self.send_position)
        subscribe("MQTT_connection", self.connection)
        subscribe("MQTT_settings", self.change_settings)

        if self.auto_connect is True:
            self.connect()

    def connection(self, state: bool):
        if state is True:
            self.connect()
        else:
            self.disconnect()

    def connect(self):
        try:
            print(self.client.connect(self.IP_address, self.port))
            self.client.loop_start()
        except Exception as e:
            print(e)

    def disconnect(self):
        self.client.disconnect()
        self.client.loop_stop()

    def send_temperature(self, data):
        if self.client.is_connected():
            self.client.publish(f"printer/{self.printer_name}/temperature", str(data))

    def send_position(self, data):
        if self.client.is_connected():
            self.client.publish(f"printer/{self.printer_name}/position", str(data))

    def change_settings(self, data: dict):
        if data.get("ip_address") is not None:
            self.IP_address = data["ip_address"]
            self.settings.setting["MQTT"]["IP_address"] = self.IP_address
            self.settings.update()

        if data.get("port") is not None:
            self.port = int(data["port"])
            self.settings.setting["MQTT"]["port"] = self.port
            self.settings.update()

        if data.get("auto_connect") is not None:
            self.auto_connect = data["auto_connect"]
            self.settings.setting["MQTT"]["auto_connect"] = self.auto_connect
            self.settings.update()

        if data.get("name") is not None:
            self.printer_name = data["name"]
            self.settings.setting["MQTT"]["name"] = self.printer_name
            self.settings.update()