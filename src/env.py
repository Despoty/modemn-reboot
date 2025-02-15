# 模块功能: 读取环境变量

import os

CONFIG = {
    "URL": os.getenv("URL", "http://192.168.1.1"),
    "USERNAME": os.getenv("USER", "user"),
    "PASSWORD": os.getenv("PASSWORD", "2HQ4Y%hf"),
    "HEADLESS": os.getenv("HEADLESS", "true").lower() == "true",
    "SCREENSHOT_DIR": os.getenv("SCREENSHOT_DIR", "/app/screenshots")
} 