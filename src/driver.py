# 模块功能: 初始化浏览器驱动

from selenium import webdriver
from selenium.webdriver.edge.service import Service as EdgeService
from selenium.webdriver.edge.options import Options as EdgeOptions
from log import logger
from env import CONFIG
import platform

def init_edge():
    """初始化浏览器驱动,适用于Windows系统"""
    try:
        edge_options = EdgeOptions()
        edge_options.add_argument("--disable-gpu")
        edge_options.add_argument("--no-sandbox")
        edge_options.add_argument("--disable-dev-shm-usage")
        
        if CONFIG['HEADLESS']:
            edge_options.add_argument("--headless=new")
        
        service = EdgeService(executable_path=CONFIG['EDGE_DRIVER_PATH'])
        driver = webdriver.Edge(service=service, options=edge_options)
        driver.set_page_load_timeout(30)
        return driver
    except Exception as e:
        logger.critical(f"浏览器初始化失败: {str(e)}")
        raise

def init_chrome():
    """初始化浏览器驱动,适用于Linux系统"""
    try:
        chrome_options = webdriver.Options()
        chrome_options.add_argument("--disable-gpu")
        chrome_options.add_argument("--no-sandbox")
        chrome_options.add_argument("--disable-dev-shm-usage")
        chrome_options.add_argument("--headless")
        driver = webdriver.Chrome(options=chrome_options)
        driver.set_page_load_timeout(30)
        return driver
    except Exception as e:
        logger.critical(f"浏览器初始化失败: {str(e)}")
        raise

def init_driver():
    """初始化浏览器驱动"""
    if platform.system() == "Windows":
        return init_edge()
    else:
        return init_chrome()