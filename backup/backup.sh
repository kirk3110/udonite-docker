#!/usr/bin/env bash
set -euo pipefail

MONGO_HOST="${MONGO_HOST:-mongo}"
MONGO_PORT="${MONGO_PORT:-27017}"
RETENTION_DAYS="${RETENTION_DAYS:-14}"

STAMP="$(date +%F-%H%M)"

# MongoDB dump
OUT_DB="/backups/mongo-${STAMP}.gz"
echo "[backup] start: $OUT_DB"
mongodump --host "${MONGO_HOST}" --port "${MONGO_PORT}" --archive --gzip > "$OUT_DB"
echo "[backup] done:  $OUT_DB"

# Audio/Image tarball
OUT_FILES="/backups/files-${STAMP}.tar.gz"
echo "[backup] start: $OUT_FILES"
tar -czf "$OUT_FILES" -C / data/audio data/image
echo "[backup] done:  $OUT_FILES"

# 古い世代を削除
find /backups -type f -name 'mongo-*.gz' -mtime +${RETENTION_DAYS} -print -delete || true
find /backups -type f -name 'files-*.tar.gz' -mtime +${RETENTION_DAYS} -print -delete || true
