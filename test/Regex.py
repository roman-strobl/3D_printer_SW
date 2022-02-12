import re

regex_Firmware = re.compile(r"([A-Z][A-Z0-9_]*):")

regex_cap = re.compile(r"(?P<name>\w*):(?P<value>[01])")

param = {}

with open('test_data/param_test.txt', 'r') as f:
    for message in f:

        if message.startswith("FIRMWARE_NAME:"):
            match = re.finditer(regex_Firmware, message)

            position = list()

            for k in match:
                position.append(message.find(k.group()))

            for k in range(len(position)):
                if k < len(position)-1:
                    name, value = message[position[k]:position[k + 1] - 1].split(":", 1)
                    param[name] = value

                else:
                    name, value = message[position[k]:-1].split(":", 1)
                    param[name] = value

        if message.startswith("Cap"):
            match = re.search(regex_cap, message)
            param[match["name"]] = match["value"]

print(param)

