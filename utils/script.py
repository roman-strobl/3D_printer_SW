import errno
import os

ROOT_DIR = os.path.dirname(os.path.abspath(__file__))
SCRIPT_DIR = os.path.join(ROOT_DIR, "scripts")

_instance_script = None


class Scripts(object):

    def __init__(self):

        self.script_list = ["start.gcode", "end.gcode", "removal.gcode", "on_pause.gcode", "on_stop.gcode"]

        dir_exist = os.path.exists(SCRIPT_DIR)

        if not dir_exist:
            os.makedirs(SCRIPT_DIR)
        else:
            for name in self.script_list:
                try:
                    file = open(os.path.join(SCRIPT_DIR, name), "x")
                    file.close()
                except OSError as ex:
                    if ex.errno != errno.EEXIST:
                        print(ex)

    def get_list_of_scripts(self) -> list:
        """
        Metoda pro získání listu možných skriptů
        :return: [Scripty]
        """
        script_list = []
        for name in self.script_list:
            fix = name.split(".")
            script_list.append(fix[0])
        return script_list

    def get_script(self, name: str) -> str:
        """
        Metoda pro získání G-kódu určitého skriptu
        :param name: Jméno skriptu
        :return:
        """
        g_code = ""
        list_index = 10
        for index, file_name in enumerate(self.script_list):
            split = file_name.split(".")
            if name == split[0]:
                list_index = index
        if list_index < len(self.script_list):
            try:
                file = open(os.path.join(SCRIPT_DIR, self.script_list[list_index]), "r")
                g_code = file.read()
                file.close()
            except OSError as ex:
                if ex.errno != errno.EEXIST:
                    print(ex)
                    return ""
            return g_code
        else:
            print("Chyba, název souboru nebyl nalezen.")
            return ""

    def update_script(self, name: str, g_code: str):
        """
        Metoda pro aktualizaci skriptu
        :param name: jméno skriptu
        :param g_code: řetězec znaků
        :return:
        """
        list_index = 10 # zde je vetší číslo, aby když program projede for cyklus a nenajde jméno souboru, tak jsem mohl zjistit chybu
        for index, file_name in enumerate(self.script_list):
            split = file_name.split(".") # zde rozdělím, ať hledám soubor bez koncovky
            if name == split[0]:
                list_index = index
        if list_index < len(self.script_list):
            try:
                file = open(os.path.join(SCRIPT_DIR, self.script_list[list_index]), "w")
                file.write(g_code)
                file.close()
            except OSError as ex:
                if ex.errno != errno.EEXIST:
                    print(ex)
        else:
            print("Chyba, název souboru nebyl nalezen.")
    

def GetScriptsManager() -> Scripts:
    global _instance_script
    if _instance_script is not None:
        return _instance_script
    else:
        _instance_script = Scripts()
        return _instance_script


if __name__ == "__main__":
    script = Scripts()
    script.update_script("end", "example")
    print(script.get_script("end"))

