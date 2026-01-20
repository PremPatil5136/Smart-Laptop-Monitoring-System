# That means: /charging-events is returning [] Output because no events are being tracked.

# If laptop is already charging → no event
# If laptop is already unplugged → no event
# Events are added only when state changes

from datetime import datetime

_events = []
_last_state = "INIT"

def track_charging_event(is_charging: bool):
    global _last_state

    if _last_state == "INIT":
        _last_state = is_charging
        return

    if is_charging != _last_state:
        _events.append({
            "charging": is_charging,
            "time": datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        })
        _last_state = is_charging

def get_charging_events():
    return _events[-20:]
