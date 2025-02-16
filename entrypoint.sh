#!/bin/sh
# 文件: /app/entrypoint.sh

# 临时文件用于存放 cron 任务
CRON_FILE="/tmp/cronjob"

if [ -n "$CRON_SCHEDULE" ]; then
  echo "Using custom cron schedule: $CRON_SCHEDULE"
  echo "$CRON_SCHEDULE python /app/src/main.py >> /app/logs/main.log 2>&1" > "$CRON_FILE"
else
  echo "Using default cron schedule: 30 0,12 * * *"
  echo "30 0,12 * * * python /app/src/main.py >> /app/logs/main.log 2>&1" > "$CRON_FILE"
fi

# 使用 alpine 内置的 crontab 指令加载任务
crontab "$CRON_FILE"

# 启动 cron 服务并在前台运行（-f）以保持容器启动，-l 设置日志级别
crond -l 8 -f