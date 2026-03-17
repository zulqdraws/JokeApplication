#!/usr/bin/env bash
set -euo pipefail

APP_DIR="/home/azureuser/jokes-app"
DB_PROFILE="${1:?DB_PROFILE is required}"
SUBMIT_IMAGE="${2:?Submit image is required}"

mkdir -p "$APP_DIR"
cd "$APP_DIR"

cat > .env.deploy <<EOF
DB_PROFILE=$DB_PROFILE
SUBMIT_IMAGE=$SUBMIT_IMAGE
EOF

echo "$DOCKERHUB_TOKEN" | docker login -u "$DOCKERHUB_USERNAME" --password-stdin

docker compose --env-file .env.deploy -f docker-compose.submit.yml pull
docker compose --env-file .env.deploy -f docker-compose.submit.yml up -d

docker image prune -af --filter "until=168h" || true
docker ps
docker compose --env-file .env.deploy -f docker-compose.submit.yml logs --tail=80