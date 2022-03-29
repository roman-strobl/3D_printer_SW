
import paho.mqtt.client as paho
from utils.settings import GetSettingsManager
from utils.Event import subscribe, post_event


class MQTT(object):

    def __init__(self):
        self.settings = GetSettingsManager()
        self.IP_address = self.settings.setting["MQTT"]["IP_address"]
        self.port = self.settings.setting["MQTT"]["port"]

        self.client = paho.Client("printer")

        self.auto_connect = self.settings.setting["MQTT"]["auto_connect"]

        subscribe("temperature_update", self.send_temperature)
        subscribe("position_update", self.send_position)

        if self.auto_connect is True:
            self.connect()

    def connect(self):
        try:
            self.client.connect(self.IP_address, self.port)
        except Exception as e:
            print(e)
        print("MQTT připojeno")
        post_event("MQTT_connection", True)

    def disconnect(self):
        self.client.disconnect()
        post_event("MQTT_connection", False)

    def send_temperature(self, data):
        self.client.publish("printer/temperature", str(data))

    def send_position(self, data):
        self.client.publish("printer/position", str(data))
