#!/usr/bin/env bash
set -euo pipefail

APP_DIR="/home/azureuser/jokes-app"

mkdir -p "$APP_DIR"
cd "$APP_DIR"

docker compose -f docker-compose.kong.yml up -d
docker ps
docker compose -f docker-compose.kong.yml logs --tail=80