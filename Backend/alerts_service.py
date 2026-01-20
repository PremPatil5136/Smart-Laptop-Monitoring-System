# alerts_service.py

from datetime import datetime

def create_alert(alert_type, message, severity="info"):
    return {
        "type": alert_type,
        "message": message,
        "severity": severity,
        "created_at": datetime.utcnow(),
        "read": False
    }
