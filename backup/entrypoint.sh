#!/usr/bin/env sh
set -eu

# 必須・既定
: "${BACKUP_CRON:?BACKUP_CRON required, e.g. \"30 3 * * *\"}"
: "${TZ:=Asia/Tokyo}"
: "${RETENTION_DAYS:=${BACKUP_RETENTION_DAYS:-14}}"

# crontab を環境変数から生成
echo "${BACKUP_CRON} /usr/local/bin/backup.sh >>/var/log/backup.log 2>&1" > /etc/crontabs/root

# フォアグラウンドで cron
exec crond -f -l 8
