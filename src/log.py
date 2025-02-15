# 模块功能: 日志

import logging
from datetime import datetime
import os
from env import CONFIG

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    datefmt='%Y-%m-%d %H:%M:%S'
)
logger = logging.getLogger(__name__)

def debug_page(driver, step):
    logger.info(f"[{step}] 页面标题: {driver.title}")
    logger.info(f"[{step}] 当前 URL: {driver.current_url}")

if __name__ == "__main__":
    logger()