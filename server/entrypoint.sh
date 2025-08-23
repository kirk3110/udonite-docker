#!/usr/bin/env sh
set -eu
envsubst < /app/default.yaml.template > /app/Udonite-Server/config/default.yaml
exec npm start --silent