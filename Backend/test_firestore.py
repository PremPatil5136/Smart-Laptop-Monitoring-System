"""
Test script to verify data is being pushed to Firestore correctly
Run this before testing the Flutter app
"""

from firebase_service import db
from battery_service import get_battery_status
from storage_service import get_storage_status
from antivirus_service import get_antivirus_status
from performance_service import get_performance_status
from system_updates_service import get_system_updates_status
from firestore_battery import push_battery_status
from firestore_system import push_system_status
from firestore_device import push_device_info
from alert_service import push_alert
from datetime import datetime

TEST_UID = "uid_12345"

def test_battery_push():
    print("\n📱 Testing Battery Status Push...")
    battery = get_battery_status()
    print(f"Battery Data: {battery}")
    
    if battery.get("available"):
        push_battery_status(TEST_UID, battery)
        print("✅ Battery status pushed to Firestore")
    else:
        print("⚠️  No battery detected")

def test_system_push():
    print("\n💻 Testing System Status Push...")
    storage = get_storage_status()
    antivirus = get_antivirus_status()
    performance = get_performance_status()
    updates = get_system_updates_status()
    
    print(f"Storage: {storage}")
    print(f"Antivirus: {antivirus}")
    print(f"Performance: {performance}")
    print(f"Updates: {updates}")
    
    system_data = {
        "storage": storage,
        "antivirus": antivirus,
        "performance": performance,
        "updates": updates
    }
    push_system_status(TEST_UID, system_data)
    print("✅ System status pushed to Firestore")

def test_device_push():
    print("\n🖥️  Testing Device Info Push...")
    push_device_info(TEST_UID)
    print("✅ Device info pushed to Firestore")

def test_alert_push():
    print("\n🔔 Testing Alert Push...")
    
    # Test different severity levels
    push_alert(TEST_UID, "Test Info Alert", "This is an info message", "info")
    push_alert(TEST_UID, "Test Warning Alert", "This is a warning message", "warning")
    push_alert(TEST_UID, "Test Critical Alert", "This is a critical message", "critical")
    
    print("✅ Test alerts pushed to Firestore")

def verify_firestore_data():
    print("\n🔍 Verifying Firestore Data...")
    
    # Check battery_status
    battery_doc = db.collection('battery_status').document(TEST_UID).get()
    if battery_doc.exists:
        print(f"✅ Battery Status: {battery_doc.to_dict()}")
    else:
        print("❌ No battery status found")
    
    # Check system_status
    system_doc = db.collection('system_status').document(TEST_UID).get()
    if system_doc.exists:
        print(f"✅ System Status: {system_doc.to_dict()}")
    else:
        print("❌ No system status found")
    
    # Check devices
    device_doc = db.collection('devices').document(TEST_UID).get()
    if device_doc.exists:
        print(f"✅ Device Info: {device_doc.to_dict()}")
    else:
        print("❌ No device info found")
    
    # Check alerts
    alerts = db.collection('alerts').where('uid', '==', TEST_UID).limit(5).stream()
    alert_count = 0
    for alert in alerts:
        alert_count += 1
        print(f"✅ Alert {alert_count}: {alert.to_dict()}")
    
    if alert_count == 0:
        print("❌ No alerts found")

if __name__ == "__main__":
    print("=" * 60)
    print("🚀 Firestore Data Push Test")
    print("=" * 60)
    
    try:
        test_battery_push()
        test_system_push()
        test_device_push()
        test_alert_push()
        
        print("\n" + "=" * 60)
        verify_firestore_data()
        print("=" * 60)
        
        print("\n✨ All tests completed!")
        print("\n📝 Next Steps:")
        print("1. Check Firebase Console to verify data")
        print("2. Run Flutter app to see real-time data")
        print("3. Run 'python main.py' to start monitoring")
        
    except Exception as e:
        print(f"\n❌ Error: {e}")
        import traceback
        traceback.print_exc()