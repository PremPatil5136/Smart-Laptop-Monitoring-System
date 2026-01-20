import psutil # type: ignore
from charging_events_service import track_charging_event
from alert_service import push_alert

LOW_BATTERY_THRESHOLD = 20
_last_charging_state = None

def _format_time(seconds):
    # Handle Windows invalid values
    if seconds in (
        psutil.POWER_TIME_UNKNOWN,
        psutil.POWER_TIME_UNLIMITED,
        None,
        -1,
        -2,
    ):
        return None

    # Block unrealistic values (> 24 hours)
    if seconds < 0 or seconds > 60 * 60 * 24:
        return None

    hours = seconds // 3600
    minutes = (seconds % 3600) // 60

    return f"{hours}h {minutes}m"

def get_battery_status():
    global _last_charging_state

    battery = psutil.sensors_battery()
    if battery is None:
        return {
            "available": False
        }

    charging_changed = False
    if _last_charging_state is not None:
        charging_changed = battery.power_plugged != _last_charging_state

    _last_charging_state = battery.power_plugged

    low_battery = (
        battery.percent <= LOW_BATTERY_THRESHOLD
        and not battery.power_plugged
    )

    return {
        "available": True,  # "available": true → Battery detected
        "percentage": int(battery.percent), # "percentage": 85 → Battery at 85%
        "charging": battery.power_plugged,  # "charging": false → Not charging
        "charging_changed": charging_changed,   # "charging_changed": true → Charging state changed since last check
        "low_battery": low_battery,  # "low_battery": true → Battery is low
        "time_left": _format_time(battery.secsleft) # "time_left": "1h 30m" → Estimated time left
    }

# Alert Page logic

def check_battery_alerts(uid, battery_percent, charging):
    if battery_percent <= 10:
        push_alert(
            uid,
            "Critical Battery",
            "Battery below 10%. Plug in immediately.",
            "critical"
        )

    elif battery_percent <= 20:
        push_alert(
            uid,
            "Low Battery",
            "Battery below 20%. Please connect charger.",
            "warning"
        )

    if charging:
        push_alert(
            uid,
            "Charging Started",
            "Laptop is plugged in and charging.",
            "info"
        )
    else:
        push_alert(
            uid,
            "Charging Stopped",
            "Laptop is running on battery.",
            "info"
        )
