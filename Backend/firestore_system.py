from firebase_service import db
from datetime import datetime

def push_system_status(uid, system_data):
    """
    Push system status to Firestore
    system_data should contain: storage, antivirus, performance, updates
    """
    storage = system_data.get("storage", {})
    antivirus = system_data.get("antivirus", {})
    performance = system_data.get("performance", {})
    updates = system_data.get("updates", {})
    
    db.collection("system_status").document(uid).set({
        # Storage info
        "storage_used_gb": storage.get("used_gb", 0),
        "storage_total_gb": storage.get("total_gb", 0),
        "storage_free_gb": storage.get("free_gb", 0),
        "storage_usage_percent": storage.get("usage_percent", 0),
        
        # Antivirus info
        "antivirus_protected": antivirus.get("protected", False),
        "antivirus_threats": antivirus.get("threats_detected", 0),
        "antivirus_last_updated": antivirus.get("definitions_last_updated", "Unknown"),
        
        # Performance info
        "cpu_usage_percent": performance.get("cpu_usage_percent", 0),
        "ram_total_gb": performance.get("ram_total_gb", 0),
        "ram_used_gb": performance.get("ram_used_gb", 0),
        "ram_usage_percent": performance.get("ram_usage_percent", 0),
        
        # System updates
        "system_updates_available": updates.get("update_available", False),
        "system_updates_status": updates.get("update_status", "Unknown"),
        "os_name": updates.get("os_name", "Unknown"),
        "os_version": updates.get("os_version", "Unknown"),
        
        "updatedAt": datetime.utcnow()
    })