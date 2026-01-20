from flask import Flask, jsonify # type: ignore
from battery_service import get_battery_status, check_battery_alerts
from storage_service import get_storage_status
from charging_events_service import get_charging_events, track_charging_event
from antivirus_service import get_antivirus_status, antivirus_alert
from performance_service import get_performance_status
from system_updates_service import get_system_updates_status, system_update_alert

from firestore_battery import push_battery_status
from firestore_system import push_system_status
from firestore_device import push_device_info

app = Flask(__name__)

# TEMP (Later this will come from auth mapping)
USER_UID = "OKYsY9ivnPN3kMxZ93BTpC4tXbo2"  # Your CURRENT Flutter app UID

@app.route("/")
def home():
    """Root endpoint - redirects to status"""
    return jsonify({
        "message": "Smart Laptop Monitoring API",
        "endpoints": {
            "status": "/status",
            "battery": "/battery",
            "storage": "/storage",
            "antivirus": "/antivirus",
            "performance": "/performance",
            "system_updates": "/system-updates",
            "charging_events": "/charging-events"
        }
    })

# Track last alert state to avoid duplicates
_last_alert_state = {
    "battery_critical": False,
    "battery_low": False,
    "charging": None,
    "antivirus_issue": False,
    "updates_pending": 0
}

@app.route("/status", methods=["GET"])
def system_status():
    global _last_alert_state
    
    battery = get_battery_status()
    storage = get_storage_status()
    charging_events = get_charging_events()
    antivirus = get_antivirus_status()
    performance = get_performance_status()
    updates = get_system_updates_status()

    # Track charging state changes
    if battery.get("available"):
        track_charging_event(battery["charging"])

    # Push data to Firestore
    if battery.get("available"):
        push_battery_status(USER_UID, battery)
    
    # Prepare system status data
    system_data = {
        "storage": storage,
        "antivirus": antivirus,
        "performance": performance,
        "updates": updates
    }
    push_system_status(USER_UID, system_data)
    push_device_info(USER_UID)

    # Create alerts only on state changes
    if battery.get("available"):
        # Critical battery alert
        if battery["percentage"] <= 10 and not _last_alert_state["battery_critical"]:
            check_battery_alerts(USER_UID, battery["percentage"], battery["charging"])
            _last_alert_state["battery_critical"] = True
            _last_alert_state["battery_low"] = False
        # Low battery alert
        elif battery["percentage"] <= 20 and battery["percentage"] > 10 and not _last_alert_state["battery_low"]:
            check_battery_alerts(USER_UID, battery["percentage"], battery["charging"])
            _last_alert_state["battery_low"] = True
            _last_alert_state["battery_critical"] = False
        # Reset alerts when battery is good
        elif battery["percentage"] > 20:
            _last_alert_state["battery_critical"] = False
            _last_alert_state["battery_low"] = False

        # Charging state change alert
        if _last_alert_state["charging"] is not None and _last_alert_state["charging"] != battery["charging"]:
            check_battery_alerts(USER_UID, battery["percentage"], battery["charging"])
        _last_alert_state["charging"] = battery["charging"]

    # Antivirus alert
    if not antivirus["protected"] and not _last_alert_state["antivirus_issue"]:
        antivirus_alert(USER_UID, "Not Protected")
        _last_alert_state["antivirus_issue"] = True
    elif antivirus["protected"]:
        _last_alert_state["antivirus_issue"] = False

    # System updates alert
    update_count = 2 if not updates["update_available"] else 0  # Placeholder
    if update_count > 0 and _last_alert_state["updates_pending"] != update_count:
        system_update_alert(USER_UID, update_count)
        _last_alert_state["updates_pending"] = update_count
    elif update_count == 0:
        _last_alert_state["updates_pending"] = 0

    return jsonify({
        "battery": battery,
        "charging_events": charging_events,
        "storage": storage,
        "antivirus": antivirus,
        "performance": performance,
        "system_updates": updates
    })


@app.route("/battery", methods=["GET"])
def battery():
    return jsonify(get_battery_status())


@app.route("/charging-events", methods=["GET"])
def charging_events():
    return jsonify(get_charging_events())


@app.route("/storage", methods=["GET"])
def storage():
    return jsonify(get_storage_status())


@app.route("/antivirus", methods=["GET"])
def antivirus():
    return jsonify(get_antivirus_status())


@app.route("/performance", methods=["GET"])
def performance():
    return jsonify(get_performance_status())


@app.route("/system-updates", methods=["GET"])
def system_updates():
    return jsonify(get_system_updates_status())


if __name__ == "__main__":
    app.run(host="127.0.0.1", port=5000, debug=True)