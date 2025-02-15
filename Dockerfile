FROM python:alpine3.6

# 安装系统依赖、chromium、chromedriver、Xvfb和cron服务（cronie）
RUN apk add --no-cache \
    chromium \
    chromium-chromedriver \
    bash \
    xorg-server \
    cronie \
    && rm -rf /var/cache/apk/*

# 安装 Selenium（如果其他依赖已经在 requirements.txt 中可不重复安装）
RUN pip install --no-cache-dir selenium

WORKDIR /app
COPY requirements.txt .
COPY src/ ./src/
COPY entrypoint.sh /app/

# 安装Python依赖
RUN pip install --no-cache-dir -r requirements.txt

# 创建日志和截图目录
RUN mkdir -p /app/{logs,screenshots} \
    && chmod 777 /app/{logs,screenshots}

# 设置环境变量
ENV SCREENSHOT_DIR=/app/screenshots
ENV HEADLESS=true
ENV CRON_SCHEDULE="30 0,12 * * *"
# alpine 使用 chromium 可设置环境变量 CHROME_BIN
ENV CHROME_BIN=/usr/bin/chromium-browser
ENV DISPLAY=:99

# 设置入口点（赋予执行权限）
RUN chmod +x /app/entrypoint.sh
ENTRYPOINT ["/app/entrypoint.sh"]