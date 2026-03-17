#!/usr/bin/env bash
set -euo pipefail

APP_DIR="/home/azureuser/jokes-app"
IMAGE_TAG="${1:?Image tag is required}"

mkdir -p "$APP_DIR"
cd "$APP_DIR"

cat > .env.deploy <<EOF
MODERATE_IMAGE=$IMAGE_TAG
MODERATE_SERVICE_PORT=3100
TYPES_CACHE_FILE=/app/cache/types-cache.json
INITIAL_TYPES_FILE=/app/defaults/types-cache.json
RABBITMQ_URL=amqp://10.10.1.30:5672
SUBMIT_QUEUE=submit
MODERATED_QUEUE=moderated
TYPE_UPDATE_EXCHANGE=type_update
MOD_TYPE_UPDATE_QUEUE=mod_type_update
EOF

echo "$DOCKERHUB_TOKEN" | docker login -u "$DOCKERHUB_USERNAME" --password-stdin

docker compose --env-file .env.deploy -f docker-compose.moderate.mongo.deploy.yml pull
docker compose --env-file .env.deploy -f docker-compose.moderate.mongo.deploy.yml up -d

docker image prune -af --filter "until=168h" || true

docker ps
docker compose --env-file .env.deploy -f docker-compose.moderate.mongo.deploy.yml logs --tail=50