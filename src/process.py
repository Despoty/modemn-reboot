# 模块功能: 浏览器操作流程

from selenium.webdriver.common.by import By
from selenium.common.exceptions import TimeoutException
from selenium.webdriver.support import expected_conditions as EC
from log import debug_page, logger as logger
from env import CONFIG
import time

def perform_login(driver, wait):
    """登录操作"""
    try:
        driver.get(CONFIG['URL'])
        debug_page(driver, "01_PageLoaded")

        wait.until(EC.presence_of_element_located(
            (By.ID, "Frm_Username"))).send_keys(CONFIG['USERNAME'])
        debug_page(driver, "02_UsernameEntered")

        driver.find_element(By.ID, "Frm_Password").send_keys(CONFIG['PASSWORD'])
        debug_page(driver, "03_PasswordEntered")
        
        driver.find_element(By.ID, "LoginId").click()
        debug_page(driver, "04_LoginClicked")
        return True
    
    except Exception as e:
        logger.error(f"登录过程异常: {str(e)}")
        debug_page(driver, "Login_Error")
        return False


def device_management_flow(driver, wait):
    """设备管理操作流程"""
    try:
        # 切换到顶层iframe
        wait.until(EC.frame_to_be_available_and_switch_to_it(
            (By.XPATH, "//iframe[contains(@src,'start.ghtml') or @id='mainFrame']"))
        )
        
        # 管理按钮操作
        manager_btn = wait.until(EC.element_to_be_clickable(
            (By.XPATH, "//font[@id='mmManager' and contains(@onclick,'manager_user')]")))
        driver.execute_script("arguments[0].click();", manager_btn)
        debug_page(driver, "05_ManagerClicked")
        time.sleep(1)

        # 设备管理操作
        device_mgmt_btn = wait.until(EC.element_to_be_clickable(
            (By.XPATH, "//a[@id='smSysMgr' and contains(@onclick,'manager_dev_restart_t.gch')]")))
        driver.execute_script("arguments[0].click();", device_mgmt_btn)
        debug_page(driver, "06_DeviceMgmtClicked")
        time.sleep(1)

        # 重启操作
        restart_btn = wait.until(EC.element_to_be_clickable((By.XPATH, "//*[@id='Submit1']")))
        driver.execute_script("arguments[0].click();", restart_btn)
        debug_page(driver, "07_RestartClicked")
        time.sleep(1)

        # 确认重启
        confirm_btn = wait.until(EC.element_to_be_clickable((By.XPATH, "//*[@id='msgconfirmb']")))
        logger.info(f"重启按钮坐标: {confirm_btn.location}")    # 输出重启按钮坐标
        driver.execute_script("arguments[0].click();", confirm_btn)
        debug_page(driver, "08_ConfirmRestartClicked")
        return True
    
    except TimeoutException as e:
        logger.error(f"操作超时: {str(e)}")
        debug_page(driver, "Timeout_Error")
        return False
    
    except Exception as e:
        logger.error(f"设备管理流程异常: {str(e)}")
        debug_page(driver, "Management_Error")
        return False