#!/bin/bash

# 设置cron任务
if [ -n "$CRON_SCHEDULE" ]; then
  echo "Using custom cron schedule: $CRON_SCHEDULE"
  echo "$CRON_SCHEDULE /usr/local/bin/python /app/src/main.py >> /app/logs/cron.log 2>&1" > /etc/cron.d/automation
else
  echo "Using default cron schedule: 30 0,12 * * *"
  echo "30 0,12 * * * /usr/local/bin/python /app/src/main.py >> /app/logs/cron.log 2>&1" > /etc/cron.d/automation
fi

# 设置文件权限
chmod 0644 /etc/cron.d/automation
crontab /etc/cron.d/automation

# 启动X虚拟帧缓冲区
Xvfb :99 -screen 0 1920x1080x24 -ac +extension GLX +render -noreset &

# 启动cron服务
service cron start

# 保持容器运行
tail -f /dev/null