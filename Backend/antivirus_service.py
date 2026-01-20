from datetime import datetime
from alert_service import push_alert

# Mocked antivirus status (UI only)
_status = {
    "protected": True,
    "threats_detected": 0,
    "definitions_last_updated": datetime.now().strftime("%Y-%m-%d %H:%M:%S")
}

def get_antivirus_status():
    return _status

# alert page
def antivirus_alert(uid, status):
    if status != "Protected":
        push_alert(
            uid,
            "Security Risk",
            "Antivirus protection is disabled.",
            "critical"
        )
