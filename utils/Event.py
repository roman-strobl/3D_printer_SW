subscribers = dict()

# todo: vytvořit Event object, ve kterém budou všechny možné eventy.

def subscribe(event_type: str, fn):
    if not event_type in subscribers:
        subscribers[event_type] = []
    subscribers[event_type].append(fn)


def post_event(event_type: str, data):
    if not event_type in subscribers:
        return
    for fn in subscribers[event_type]:
        if data is None:
            fn()
        else:
            fn(data)


class Event(object):

    TEMPERATURE = "temperature_update"
    POSITION = "position_update"
