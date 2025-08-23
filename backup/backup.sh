#!/usr/bin/env bash
set -euo pipefail

MONGO_HOST="${MONGO_HOST:-mongo}"
MONGO_PORT="${MONGO_PORT:-27017}"
RETENTION_DAYS="${RETENTION_DAYS:-14}"

STAMP="$(date +%F-%H%M)"
OUT="/backups/mongo-${STAMP}.gz"

echo "[backup] start: $OUT"
mongodump --host "${MONGO_HOST}" --port "${MONGO_PORT}" --archive --gzip > "$OUT"
echo "[backup] done: $OUT"

# 古い世代を削除
find /backups -type f -name 'mongo-*.gz' -mtime +${RETENTION_DAYS} -print -delete || true