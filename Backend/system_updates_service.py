# system_updates_service.py

import platform
from datetime import datetime
from alert_service import push_alert

def get_system_updates_status():
    return {
        "os_name": platform.system(),
        "os_version": platform.release(),
        "update_available": False,   # placeholder (real check later)
        "update_status": "Up to date",
        "last_checked": datetime.utcnow()
    }

# alert_service.py

def system_update_alert(uid, pending_updates):
    if pending_updates > 0:
        push_alert(
            uid,
            "System Update Available",
            f"{pending_updates} updates pending.",
            "warning"
        )
