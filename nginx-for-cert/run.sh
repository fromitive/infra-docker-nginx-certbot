#!/bin/bash

set -e

if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Usage: ./run.sh [yourdomain.com] [youremail@example.com]"
  exit 1
fi


DOMAIN="$1"
EMAIL="$2"
CURRENT_DATE=$(date +"%y%m%d")
PROJECT_NAME="certbot_$CURRENT_DATE"
CERTIFICATIONS_PATH="../certifications"

sed "s/DOMAIN_HERE/${DOMAIN}/g" ./nginx/conf.d/default.conf.template > ./nginx/conf.d/default.conf

docker compose -p "$PROJECT_NAME" up -d nginx_for_cert

docker compose -p "$PROJECT_NAME" \
	run --rm certbot certonly --webroot -w /var/www/html -d "$DOMAIN" --agree-tos --email "$EMAIL" --non-interactive

echo "Certbot has completed. Stopping only certbot related containers..."

docker compose -p "$PROJECT_NAME" down
rm -rf ./nginx/conf.d/default.conf

echo "change all certification permission"
find "$CERTIFICATIONS_PATH" -type f -exec chmod 400 {} \;

