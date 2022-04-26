import requests
import threading


class States(object):
    INIT = "init"
    REQUEST = "request"
    PRINTING = "printing"
    REMOVAL = "removal"


class StateMachine(object):

    def __init__(self):
        self._state = States.INIT
        self._thread = threading.Thread(target=self.state_loop, name="state_machine_loop")
        self._running = threading.Event()

    def state_loop(self):
        while True:
            pass

    def Init_state(self):
        pass
