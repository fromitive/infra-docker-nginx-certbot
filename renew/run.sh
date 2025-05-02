#!/bin/bash

ORIGINAL_DIR="$(pwd)"

ABSOLUTE_SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

cd "${ABSOLUTE_SCRIPT_DIR}" || exit 1

set -e

if [ -z "$1" ]; then
  echo "Usage: ./run.sh [applied_ssl_nginx_container_name]"
  exit 1
fi

CONTAINER_NAME="$1"
CERTIFICATIONS_PATH="../certifications"

echo "[+] Renew certificate"
docker compose run certbot

echo "[+] apply new certificate"
docker exec $CONTAINER_NAME nginx -s reload

echo "[-] stop nginx for cert"
docker compose down

echo "change all certification permission"
find "$CERTIFICATIONS_PATH" -type f -exec chmod 400 {} \;

cd "${ORIGINAL_DIR}"