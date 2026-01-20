from firebase_service import db
from datetime import datetime
import platform

def push_device_info(uid):
    db.collection("devices").document(uid).set({
        "deviceName": platform.node(),
        "os": platform.system() + " " + platform.release(),
        "lastSeen": datetime.utcnow()
    })
