# 使用官方Python基础镜像
FROM python:3.9-slim

# 安装系统依赖和Edge浏览器
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    gpg-agent \
    libx11-xcb1 \
    libdrm2 \
    libgbm1 \
    libasound2 \
    libatk-bridge2.0-0 \
    libgtk-3-0 \
    libnss3 \
    fonts-liberation \
    --no-install-recommends

# 安装Microsoft Edge浏览器
RUN wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | apt-key add - \
    && echo "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge.list \
    && apt-get update \
    && apt-get install -y microsoft-edge-stable

# 安装Edge WebDriver
RUN EDGE_VERSION=$(microsoft-edge --version | awk '{print $3}') \
    && DRIVER_VERSION=${EDGE_VERSION%.*} \
    && wget -q "https://msedgedriver.azureedge.net/${DRIVER_VERSION}/edgedriver_linux64.zip" -O /tmp/edgedriver.zip \
    && unzip /tmp/edgedriver.zip -d /usr/bin/ \
    && chmod +x /usr/bin/msedgedriver \
    && rm /tmp/edgedriver.zip

# 设置工作目录
WORKDIR /app
COPY requirements.txt .
COPY src/ ./src/

# 安装Python依赖
RUN pip install --no-cache-dir -r requirements.txt

# 创建截图目录
RUN mkdir -p /app/screenshots && chmod 777 /app/screenshots

# 设置环境变量默认值
ENV URL=http://192.168.1.1
ENV USER=user
ENV PASSWORD=2HQ4Y%hf
ENV HEADLESS=true
ENV SCREENSHOT_DIR=/app/screenshots

# 设置容器启动命令
CMD ["python", "src/main.py"]