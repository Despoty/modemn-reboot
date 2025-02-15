from selenium import webdriver
from selenium.webdriver.chrome.service import Service as ChromeService
from selenium.webdriver.chrome.options import Options as ChromeOptions
from log import logger
from env import CONFIG

def init_driver():
    """初始化Chrome浏览器驱动"""
    try:
        chrome_options = ChromeOptions()
        
        if CONFIG['HEADLESS']:
            chrome_options.add_argument("--headless=new")
        
        chrome_options.add_argument("--disable-gpu")
        chrome_options.add_argument("--no-sandbox")
        chrome_options.add_argument("--disable-dev-shm-usage")
        chrome_options.add_argument("--window-size=1920x1080")
        
        driver = webdriver.Chrome(options=chrome_options)
        driver.set_page_load_timeout(30)
        return driver
    except Exception as e:
        logger.critical(f"浏览器初始化失败: {str(e)}")
        raise