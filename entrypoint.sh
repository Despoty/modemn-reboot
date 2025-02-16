#!/bin/sh

CRON_FILE="/tmp/cronjob"

if [ -n "$CRON_SCHEDULE" ]; then
  echo "Using custom cron schedule: $CRON_SCHEDULE"
  echo "$CRON_SCHEDULE /usr/local/bin/python /app/src/main.py" > "$CRON_FILE"
else
  echo "Using default cron schedule: 30 0,12 * * *"
  echo "30 0,12 * * * /usr/local/bin/python /app/src/main.py" > "$CRON_FILE"
fi

# 安装 cron 任务
crontab "$CRON_FILE"

# 启动 cron 服务（后台运行）
crond -l 8 &
 
# 防止容器退出，阻塞方式等待
tail -F /app/logs/main.log