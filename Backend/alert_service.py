# That psge for automatical create alert when battery is low or charging state changes

from firebase_service import db
from datetime import datetime

def push_alert(uid, title, message, severity):
    alert = {
        "uid": uid,
        "title": title,
        "message": message,
        "severity": severity,   # info / warning / critical
        "createdAt": datetime.utcnow()
    }
    db.collection("alerts").add(alert)

