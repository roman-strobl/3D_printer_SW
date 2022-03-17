
import paho.mqtt.client as paho

def _init_mqtt() -> paho.Client:
    client = paho.Client("printer")

    try:
        client.connect("192.168.0.207", 1883)
    except Exception as e:
        print(e)

    return client


client = _init_mqtt()