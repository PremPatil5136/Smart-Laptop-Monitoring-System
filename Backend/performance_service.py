import psutil

def get_performance_status():
    cpu_percent = psutil.cpu_percent(interval=1)
    memory = psutil.virtual_memory()

    return {
        "cpu_usage_percent": cpu_percent,
        "ram_total_gb": round(memory.total / (1024 ** 3), 2),
        "ram_used_gb": round(memory.used / (1024 ** 3), 2),
        "ram_available_gb": round(memory.available / (1024 ** 3), 2),
        "ram_usage_percent": memory.percent
    }

if __name__ == "__main__":
    print(get_performance_status())
