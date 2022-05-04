import json
import os
from enum import Enum

import requests
from requests.exceptions import HTTPError

_instance = None


class PrinterSettings:
    """Class that provides settings for printer Class from json file."""
    data: dict

    def __init__(self, file: str):
        self.file = file

        with open(self.file, "r") as read_file:
            self.data = json.load(read_file)

    def _change_file(self, file: str):
        self.file = file

        with open(self.file, "r") as read_file:
            self.data = json.load(read_file)

    def list_of_profiles(self) -> list[str]:
        """Find all profile in Json file

        :return: list of profiles
        """
        return list(self.data.keys())

    def load_profile(self, profile: str) -> dict:
        """Find prifile and return dict of options for profile

        :return: dict of options
        """
        return self.data.get(profile)

    def add_profile(self, profile: str, options: dict) -> None:
        new_dict = {profile: options}
        self.data.update(new_dict)
        # print(self.data)
        with open(self.file, "w") as write_file:
            json.dump(self.data, write_file, indent=4)

    def del_profile(self, profile: str):
        self.data.pop(profile)
        # print(self.data)
        with open(self.file, "w") as write_file:
            json.dump(self.data, write_file, indent=4)


default_setting = {
        "serial": {
            "port": "COM1",
            "baudrate": 250000,
            "auto_connect": False,
        },
        "printer": {
            "temperature_report": True,
            "temperature_report_interval": 4,
            "position_report": True,
            "position_report_interval": 1,
            "num_of_extruder": 1,
            "extruder": {
                "max_temp": [250]
            },
            "bed": {
                "state": True,
                "max_temp": 60,
            },
            "chamber": {
                "state": False,
                "max_temp": 50,
            },
            "reports_interval": {
                "temperature": 4,
                "position": 1,
            }
        },
        "MQTT": {
            "IP_address": "127.0.0.1",
            "port": 1883,
            "auto_connect": False,
        },
        "MES": {
            "IP_address": "192.168.0.116",
            "port": 80,
            "url": "http://192.168.0.116:5000/printer/config",
        },
        "GUI": {
            "baudrates": [250000, 115200, 230400, 57600, 38400, 19200, 9600],
        },
        "system": {
            "status": True,
            "removal": "manual",
        },
}

__location__ = os.path.realpath(
    os.path.join(os.getcwd(), os.path.dirname(__file__)))


class SettingType:
    SERIAL = "serial"
    PRINTER = "printer"
    MQTT = "MQTT"
    MES = "MES"
    GUI = "GUI"


class Settings(object):

    setting = {}

    def __init__(self, basedir: str = None):

        if basedir is None:
            try:
                with open("setting.json", "r+") as file:
                    self.setting = json.load(file)
            except IOError:
                with open("setting.json", "w") as file:
                    self.setting = default_setting
                    json.dump(self.setting, file, indent=4)
        else:
            try:
                with open(basedir, "r+") as file:
                    self.setting = json.load(file)
            except IOError:
                print("Soubor neexistuje")
                with open(basedir, "w") as file:
                    self.setting = default_setting
                    json.dump(self.setting, file, indent=4)

    def update(self):
        with open("setting.json", "w") as file:
            json.dump(self.setting, file, indent=4)

    def updateSettingFromUrl(self, url: str) -> None:
        new_setting = self._getJsonFromUrl(url)

        if new_setting == {}:
            print("Nepodařilo se stáhnout soubor")
            return

        self.setting = new_setting

        self.update()

    @staticmethod
    def _getJsonFromUrl(url: str) -> dict:
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


def GetSettingsManager() -> Settings:
    global _instance

    if _instance is not None:
        return _instance
    else:
        _instance = Settings()
        return _instance


if __name__ == '__main__':
    URL = 'http://127.0.0.1:5000/printer/config'
    setting = Settings()
    setting.updateSettingFromUrl(URL)
