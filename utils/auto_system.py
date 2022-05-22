import time
import os
import requests
import threading
import urllib.parse

from requests import HTTPError

from utils.settings import GetSettingsManager, Settings
from utils.Event import fire_event, subscribe


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
        self._next_status.clear()
        self._comm_status = False
        self.settings = GetSettingsManager()

        self.printer_name = self.settings.setting["MQTT"]["name"]
        self._status = self.settings.setting["system"]["status"]
        self._removal_mode = self.settings.setting["system"]["removal"]
        self._MES_url = self.settings.setting["MES"]["url"]

        self._thread.start()

        self._job_id = 0

        subscribe("system_state", self.event_handler)
        subscribe("MES_url", self._change_mes_url)
        subscribe("printer_connection", self._printer_status)
        subscribe("MQTT_settings", self._change_printer_name)
        subscribe("Serial_ERROR", self._serial_error)

    def _change_printer_name(self, data: dict):
        if data.get("name") is not None:
            self.printer_name = data["name"]

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
            time.sleep(5)
            if self._comm_status:
                self._state = States.REQUEST
                self._next_status.clear()
                return

        self._next_status.wait()
        self._next_status.clear()

    def Request_state(self):
        if not self._status:
            print("vypnuti systemu")
            self._state = States.IDLE
            return
        print("Request_state")
        file = self._getFileFromQueue(self._MES_url)
        if file == "":
            time.sleep(5)
            return
        fire_event("printer_start_print", file)
        print(f"Tisk souboru {file}")
        self._state = States.PRINTING
        self._next_status.clear()

    def Printing_state(self):
        print("printing_state")
        self._next_status.wait()
        if self._state == States.PRINTING:
            self._state = States.REMOVAL
        elif self._state == States.IDLE:
            return
        self._next_status.clear()
        requests.post(self._MES_url,
                      json={"id": self._job_id, "status": "done", "printer": self.printer_name})

        if os.path.exists("job.gcode"):
            os.remove("job.gcode")
            print("The file has been deleted successfully")
        else:
            print("The file does not exist!")

    def Removal_state(self):
        if self._removal_mode == "manual":
            fire_event("GUI_removal_dialog", None)
        elif self._removal_mode == "auto":
            fire_event("printer_auto_removal", None)

        print("Removal_state")
        self._next_status.wait()
        self._state = States.IDLE
        self._next_status.clear()

    def _getFileFromQueue(self, url: str):
        first_response = self._getJsonFromUrl(url)
        self._job_id = first_response.get("id")

        if first_response == {}:
            return ""
        if first_response.get("url") is None:
            return ""
        if first_response.get("id") is None:
            return ""

        file_url = first_response.get("url")

        job_id = first_response.get("id")

        if file_url == "":
            return ""
        if job_id == 0:
            return ""

        print(f"File url: {file_url}")

        if "localhost" in file_url:
            parsed_url = urllib.parse.urlparse(self._MES_url)
            file_url = file_url.lstrip("localhost")
            file_url = parsed_url.scheme + "://" + parsed_url.netloc + file_url

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

        response = {
            "id":  self._job_id,
            "status": "printing",
            "printer": self.printer_name,
            "MQTT": f"/printer/{self.printer_name}"
        }
        requests.post(url, json=response)

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
            print(r.url)

        try:
            response = r.json()
        except Exception as json_error:
            return {}
        return response

    def event_handler(self, status: str):
        if status == "done":
            self._next_status.set()

        elif status == "removed":
            self._next_status.set()

        elif status == "start":
            self._status = True
            if self._state == States.IDLE:
                self._next_status.set()
            self.settings.setting["system"]["status"] = self._status
            self.settings.update()

        elif status == "stop":
            self._status = False
            self.settings.setting["system"]["status"] = self._status
            self.settings.update()

        elif status == "manual":
            self._removal_mode = "manual"
            self.settings.setting["system"]["removal"] = self._removal_mode
            self.settings.update()

        elif status == "auto":
            self._removal_mode = "auto"
            self.settings.setting["system"]["removal"] = self._removal_mode
            self.settings.update()

        elif status == "stopped":
            if self._state == States.PRINTING:
                requests.post(self._MES_url,
                              json={"id": self._job_id, "status": "failed", "printer": self.printer_name})
                self._status = False
                self._state = States.IDLE
                if os.path.exists("job.gcode"):
                    os.remove("job.gcode")
                    print("The file has been deleted successfully")
                else:
                    print("The file does not exist!")

    def _serial_error(self, error):
        if self._state == States.PRINTING:
            requests.post(self._MES_url,
                          json={"id": self._job_id, "status": "failed", "printer": self.printer_name})
            self._status = False
            self._state = States.IDLE
            if os.path.exists("job.gcode"):
                os.remove("job.gcode")
                print("The file has been deleted successfully")
            else:
                print("The file does not exist!")


    def _printer_status(self, stat: str):
        if stat == "CONNECTED":
            self._comm_status = True
            self._next_status.set()

        elif stat == "DISCONNECTED":
            self._comm_status = False

    def _change_mes_url(self, url):
        self._MES_url = url
        self.settings.setting["MES"]["url"] = self._MES_url
        self.settings.update()




