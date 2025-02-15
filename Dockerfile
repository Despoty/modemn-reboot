FROM python:3.9-slim

# 安装系统依赖
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    cron \
    unzip \
    libglvnd0 \
    libgl1 \
    libglx0 \
    libegl1 \
    libxext6 \
    libx11-6 \
    xvfb \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# 安装Google Chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update \
    && apt-get install -y google-chrome-stable

# 安装匹配的ChromeDriver
RUN CHROME_VERSION=$(google-chrome-stable --version | awk '{print $3}' | cut -d'.' -f1) \
    && CHROMEDRIVER_VERSION=$(wget -qO- https://chromedriver.storage.googleapis.com/LATEST_RELEASE_${CHROME_VERSION}) \
    && wget -q "https://chromedriver.storage.googleapis.com/${CHROMEDRIVER_VERSION}/chromedriver_linux64.zip" -O /tmp/chromedriver.zip \
    && unzip /tmp/chromedriver.zip -d /usr/bin/ \
    && chmod +x /usr/bin/chromedriver \
    && rm /tmp/chromedriver.zip

WORKDIR /app
COPY requirements.txt .
COPY src/ ./src/
COPY entrypoint.sh /app/

# 安装Python依赖
RUN pip install --no-cache-dir -r requirements.txt

# 创建日志和截图目录
RUN mkdir -p /app/{logs,screenshots} && chmod 777 /app/{logs,screenshots}

# 设置环境变量
ENV SCREENSHOT_DIR=/app/screenshots
ENV HEADLESS=true
ENV CRON_SCHEDULE="30 0,12 * * *"
ENV DISPLAY=:99

# 设置入口点
RUN chmod +x /app/entrypoint.sh
ENTRYPOINT ["/app/entrypoint.sh"]