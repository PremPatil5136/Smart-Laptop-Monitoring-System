from firebase_service import db
from datetime import datetime

def push_battery_status(uid, battery):
    db.collection("battery_status").document(uid).set({
        "percentage": battery["percentage"],
        "charging": battery["charging"],
        "low_battery": battery["low_battery"],
        "time_left": battery.get("time_left"),
        "updatedAt": datetime.utcnow()
    })
