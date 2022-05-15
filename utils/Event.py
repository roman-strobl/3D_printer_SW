subscribers = dict()


def subscribe(event: str, fn):
    if not event in subscribers:
        subscribers[event] = []
    subscribers[event].append(fn)

def fire_event(event: str, data):
    if not event in subscribers:
        return
    for fn in subscribers[event]:
        if data is None:
            fn()
        else:
            fn(data)

