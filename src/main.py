# 主程序入口

from selenium.webdriver.support.ui import WebDriverWait
import time
from log import logger
from driver import init_driver
from process import perform_login, device_management_flow

def main():
    driver = init_driver()
    wait = WebDriverWait(driver, 20)
    try:
        if not perform_login(driver, wait):
            return

        if not device_management_flow(driver, wait):
            return
        logger.info("设备重启流程已成功触发，等待设备重启...")
        time.sleep(100)
    finally:
        driver.quit()
        logger.info("浏览器实例已安全关闭")

if __name__ == "__main__":
    main()