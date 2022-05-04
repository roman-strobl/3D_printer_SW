import time

import requests
import threading

from PySide2.QtCore import QTimer
from requests import HTTPError

from utils.settings import GetSettingsManager, Settings
from utils.Event import post_event, subscribe


class States(object):
    IDLE = "idle"
    REQUEST = "request"
    PRINTING = "printing"
    REMOVAL = "removal"


class StateMachine(object):

    def __init__(self):
        self._state = States.IDLE
        self._thread = threading.Thread(target=self.state_loop, name="state_machine_loop")
        self._thread.daemon = True
        self._next_status = threading.Event()
        self._comm_status = False
        self.settings = GetSettingsManager()

        self._status = self.settings.setting["system"]["status"]
        self._removal_mode = self.settings.setting["system"]["removal"]
        self._MES_url = self.settings.setting["MES"]["url"]

        self._thread.start()

        subscribe("system_state", self.event_handler)
        subscribe("printer_connection", self._printer_status)

    def state_loop(self):
        while True:
            if self._state == States.IDLE:
                self.Idle_state()

            elif self._state == States.REQUEST:
                self.Request_state()

            elif self._state == States.PRINTING:
                self.Printing_state()

            elif self._state == States.REMOVAL:
                self.Removal_state()

    def Idle_state(self):
        print("Idle_state")

        if self._status:
            if self._comm_status:
                self._state = States.REQUEST
                return

        self._next_status.wait()

    def Request_state(self):
        print("Request_state")
        file = self._getFileFromQueue("http://192.168.0.116:5000/printer/queue")
        if file == "":
            time.sleep(5)
            return

        post_event("printer_start_print", file)
        print(f"Tisk souboru {file}")
        self._state = States.PRINTING

    def Printing_state(self):
        print("printing_state")
        self._next_status.wait()
        self._state = States.REMOVAL
        self._next_status.clear()

    def Removal_state(self):
        if self._removal_mode == "manual":
            post_event("GUI_removal_dialog")
        print("Removal_state")
        self._next_status.wait()
        self._state = States.IDLE
        self._next_status.clear()

    def _getFileFromQueue(self, url: str):
        first_response = self._getJsonFromUrl(url)
        if first_response == {}:
            return ""
        file_url = first_response.get("url")
        print(f"File url: {file_url}")
        if file_url == "":
            return ""
        file_url = self._MES_url + file_url
        print(f"File url: {file_url}")
        try:
            r = requests.get(file_url)
            if r.status_code != 200:
                print(f"HTML error code: {r.status_code}")
                return ""
        except HTTPError as http_err:
            print(f'HTTP error occurred: {http_err}')
            return ""
        except Exception as err:
            print(f'Other error occurred: {err}')
            return ""
        else:
            print('Success!')

        file = open("job.gcode", "wb")
        file.write(r.content)
        file.close()

        return "job.gcode"

    @staticmethod
    def _getJsonFromUrl(url: str) -> dict:
        r = dict
        try:
            r = requests.get(url)
            if r.status_code != 200:
                print(f"HTML error code: {r.status_code}")
                return {}
        except HTTPError as http_err:
            print(f'HTTP error occurred: {http_err}')
            return {}
        except Exception as err:
            print(f'Other error occurred: {err}')  # Python 3.6
            return {}
        else:
            print('Success!')

        return r.json()

    def event_handler(self, status: str):
        if status == "done":
            self._next_status.set()

    def _printer_status(self, stat: str):
        if stat == "CONNECTED":
            self._comm_status = True
            self._next_status.set()

        elif stat == "DISCONNECTED":
            self._comm_status = False


if __name__ == "__main__":
    def hello(path:str):
        print(f"Budu tisknout soubor {path}")

    subscribe("printer_start_print", hello)
    URL = "http://127.0.0.1:5000/printer/queue"
    Machinka = StateMachine()



