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
