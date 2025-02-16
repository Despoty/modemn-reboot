# 安装Selenium
FROM python:3.8.8-alpine3.13 AS build
RUN apk update && \
    apk add --no-cache gcc libffi-dev musl-dev && \
    pip install -U pip && \
    pip install --timeout 30 --user --no-cache-dir --no-warn-script-location selenium


FROM python:3.8.8-alpine3.13 
# 将构建阶段的依赖包复制到当前镜像
ENV LOCAL_PKG="/root/.local"
COPY --from=build ${LOCAL_PKG} ${LOCAL_PKG}

# 安装系统依赖、chromium、chromedriver、bash、xorg-server、libexif、udev
RUN apk update \
    && apk add --no-cache \
    chromium \
    chromium-chromedriver \
    bash \
    xorg-server \
    libexif\
    udev \
    vim \
    curl \
    unzip \
    xvfb-run \
    && rm -rf /var/cache/apk/*

RUN pip install --no-cache-dir --break-system-packages selenium

WORKDIR /app
COPY requirements.txt .
COPY src/ ./src/
COPY entrypoint.sh /app/

# 安装Python依赖
RUN pip install --no-cache-dir --break-system-packages -r requirements.txt

# 创建日志和截图目录
RUN mkdir -p /app/logs /app/screenshots \
    && chmod 777 /app/logs /app/screenshots

# 设置环境变量
ENV SCREENSHOT_DIR=/app/screenshots
ENV HEADLESS=true

# 设置入口点（赋予执行权限）
RUN chmod +x /app/entrypoint.sh
ENTRYPOINT ["/app/entrypoint.sh"]