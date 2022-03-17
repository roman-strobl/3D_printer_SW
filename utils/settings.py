import json
import os

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
            "baudrate": 250000
        },
        "printer": {
            "num_of_extruder": 1,
            "extruder": {
                "first": {
                    "max_temp": 250
                }
            },
            "bed": {
                "state": True,
                "max_temp": 60,
            },
            "chamber": {
                "state": False,
                "max_temp": 50,
            }
        },
        "MQTT": {
            "IP_address": "127.0.0.1",
            "port": 1883
        },
        "MES": {
            "IP_address": "127.0.0.1",
            "port": 80
        },
}

__location__ = os.path.realpath(
    os.path.join(os.getcwd(), os.path.dirname(__file__)))


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




if __name__ == '__main__':

    setting = Settings()

