#!/usr/bin/env sh
set -eu
: "${PUBLIC_URL:?PUBLIC_URL required}"
: "${BCDICE_API_URL:?BCDICE_API_URL required}"
# Angularクライアントが読む設定を起動時に生成（再ビルド不要）
envsubst < /usr/share/nginx/html/assets/config.yaml.template > /usr/share/nginx/html/assets/config.yaml
exec nginx -g 'daemon off;'