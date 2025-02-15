#!/bin/bash

# 设置cron任务：将任务写入cron文件，同时重定向python输出到日志文件
if [ -n "$CRON_SCHEDULE" ]; then
  echo "Using custom cron schedule: $CRON_SCHEDULE"
  echo "$CRON_SCHEDULE python /app/src/main.py >> /app/logs/main.log 2>&1" | crontab -
else
  echo "Using default cron schedule: 30 0,12 * * *"
  echo "30 0,12 * * * python /app/src/main.py >> /app/logs/main.log 2>&1" | crontab -
fi

# 启动X虚拟帧缓冲区
Xvfb :99 -screen 0 1920x1080x24 -ac +extension GLX +render -noreset &

# 启动cron服务
crond

# 将python运行日志tail到控制台，保持容器运行
tail -f /app/logs/main.log