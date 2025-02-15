#!/bin/sh
# 文件: /app/entrypoint.sh

# 写入cron配置到 /etc/crontabs/root
if [ -n "$CRON_SCHEDULE" ]; then
  echo "Using custom cron schedule: $CRON_SCHEDULE"
  echo "$CRON_SCHEDULE python /app/src/main.py >> /app/logs/main.log 2>&1" > /etc/crontabs/root
else
  echo "Using default cron schedule: 30 0,12 * * *"
  echo "30 0,12 * * * python /app/src/main.py >> /app/logs/main.log 2>&1" > /etc/crontabs/root
fi

# 确保 /etc/crontabs/root 权限为755
chmod 755 /etc/crontabs/root

# 启动X虚拟帧缓冲区
Xvfb :99 -screen 0 1920x1080x24 -ac +extension GLX +render -noreset &

# 启动cron服务并在前台运行（-f）以保持容器启动，-l 设置日志级别
crond -l 8 -f