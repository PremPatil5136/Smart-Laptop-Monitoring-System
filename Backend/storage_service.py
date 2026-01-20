import psutil

def get_storage_status():
    disk = psutil.disk_usage('/')
    return {
        "total_gb": round(disk.total / (1024**3), 2),
        "used_gb": round(disk.used / (1024**3), 2),
        "free_gb": round(disk.free / (1024**3), 2),
        "usage_percent": disk.percent
    }

if __name__ == "__main__":
    print(get_storage_status())
