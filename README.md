# 3D_printer_SW
EN:
This project is Bachelor thesis, where i was trying programming control system for 3D printing farm.

To turn on the control system, you need to create a virtual environment inside the folder using the command:

python3 -m venv venv

then you activate the virtual environment and install the necessary libraries using the command:

pip install -r requirements.txt

then just run main.py to turn on the system


To enable simulation_MES, you need to create a virtual environment inside the folder using the command:

python3 -m venv venv

then you activate the virtual environment and install the necessary libraries using the command:

pip install -r requirements.txt

After installation, the server can be started with commands in CMD:
set FLASK_APP=flaskr
set FLASK_ENV=development
flask run --host=0.0.0.0

commands in BASH:
export FLASK_APP=flaskr
export FLASK_ENV=development
flask run --host=0.0.0.0

Then at the URL address 127.0.0.1/
you will find the G-code upload page.

CZ:
Pro zapnutí řídicího systému je potřeba si vytvořit virtuální prostředí uvnitř složky pomocí příkazu:

python3 -m venv venv

poté aktivujete virtuální prostředí a nainstalujeme potřebné knihovny pomocí příkazu:

pip install -r requirements.txt

pro zapnutí systému potom stačí spustit main.py


Pro zapnutí simulaci_MES je potřeba si vytvořit virtuální prostředí uvnitř složky pomocí příkazu:

python3 -m venv venv

poté aktivujete virtuální prostředí a nainstalujeme potřebné knihovny pomocí příkazu:

pip install -r requirements.txt

Po naistalování lze spustit server příkazy v CMD:
set FLASK_APP=flaskr
set FLASK_ENV=development
flask run --host=0.0.0.0

a nebo příkazy v BASH:
export FLASK_APP=flaskr
export FLASK_ENV=development
flask run --host=0.0.0.0

Poté na URL adrese 127.0.0.1/
najdete stránku pro upload G-kódu.
