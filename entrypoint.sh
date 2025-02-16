#!/bin/sh
# 临时文件用于存放 cron 任务
CRON_FILE="/tmp/cronjob"

if [ -n "$CRON_SCHEDULE" ]; then
  echo "Using custom cron schedule: $CRON_SCHEDULE"
  echo "$CRON_SCHEDULE /usr/local/bin/python /app/src/cron.py >> /app/logs/cron.log 2>&1" > "$CRON_FILE"
else
  echo "Using default cron schedule: 30 0,12 * * *"
  echo "30 0,12 * * * /usr/local/bin/python /app/src/cron.py >> /app/logs/cron.log 2>&1" > "$CRON_FILE"
fi

# 加载 cron 任务
crontab "$CRON_FILE"

# 后台启动 cron 服务
crond -l 8 &
 
# 将日志文件的输出实时转发到标准输出
tail -F /app/logs/cron.log