import unittest
from settings.settings import PrinterSettings
import json
import os

test_dict_add = {
  "Profile1": {
    "port": "COM1",
    "baudrate": 250000,
    "XON/XOFF": False
  },
  "Profile2": {
    "port": "COM2",
    "baudrate": 250000,
    "XON/XOFF": False
  },
  "Profile3": {
    "port": "COM3",
    "baudrate": 250000,
    "XON/XOFF": False
  },
  "Profile4": {
    "port": "COM4",
    "baudrate": 250000,
    "XON/XOFF": False
  }
}

test_dict_del = {
  "Profile1": {
    "port": "COM1",
    "baudrate": 250000,
    "XON/XOFF": False
  },
  "Profile2": {
    "port": "COM2",
    "baudrate": 250000,
    "XON/XOFF": False
  },
  "Profile3": {
    "port": "COM3",
    "baudrate": 250000,
    "XON/XOFF": False
  }
}

class MyTestCase(unittest.TestCase):

    def setUp(self):
        self.kek = PrinterSettings("test_data/test_settings.json")

    def test_profile_list(self):
        self.assertEqual(["Profile1", "Profile2", "Profile3"], self.kek.list_of_profiles()
                         , "Pole nejsou stejná")

    def test_profile_load(self):
        self.assertEqual({"port": "COM2", "baudrate": 250000, "XON/XOFF": False}, self.kek.load_profile("Profile2")
                         , "Profil se nenačetl správně")

    def test_profile_add(self):
        self.kek._change_file("test_data/test_settings_add.json")
        self.kek.add_profile("Profile4", {"port": "COM4",
                                          "baudrate": 250000,
                                          "XON/XOFF": False
                                          })
        new_dict: dict
        with open("test_data/test_settings_add.json", "r") as read_file:
            new_dict = json.load(read_file)
        self.assertEqual(test_dict_add, new_dict, "Nový profil se nepřidal, nebo se přidal špatně")

    def test_profile_delete(self):
        self.kek._change_file("test_data/test_settings_add.json")
        self.kek.del_profile("Profile4")
        new_dict: dict
        with open("test_data/test_settings_add.json", "r") as read_file:
            new_dict = json.load(read_file)
        self.assertEqual(test_dict_del, new_dict, "Profil se nesmazal")


if __name__ == '__main__':
    unittest.main()
