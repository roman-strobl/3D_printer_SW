subscribers = dict()


def subscribe(event: str, fn):
    """Funkce pro odebírání určitého eventu"""
    if event not in subscribers:
        subscribers[event] = []
    subscribers[event].append(fn)


def fire_event(event: str, data=None):
    """Funkce pro aktivaci určitého eventu"""
    if event not in subscribers:
        return
    for fn in subscribers[event]:
        if data is None:
            fn()
        else:
            fn(data)
