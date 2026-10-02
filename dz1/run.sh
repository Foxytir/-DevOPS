#!/usr/bin/env bash
set -e

PREFIX=ahmetov-04
APP_PORT_HOST=8012
APP_PORT_CONT=5004
DB_PORT_HOST=8014
DB_PORT_CONT=3306
IMAGE_VER=2.0

echo "=== Удаляем прежние контейнеры приложения и базы ==="
docker rm -f ${PREFIX}-web ${PREFIX}-db 2>/dev/null || true

echo "=== Собираем образ ${PREFIX}/probe:${IMAGE_VER} ==="
docker build --build-arg VERSION=${IMAGE_VER} -t ${PREFIX}/probe:${IMAGE_VER} .

echo "=== Создаём том ${PREFIX}-data (если нет) ==="
docker volume create ${PREFIX}-data

echo "=== Запускаем базу ==="
docker run -d \
  --name ${PREFIX}-db \
  -e MARIADB_ROOT_PASSWORD=lab \
  -e MARIADB_DATABASE=lab \
  -p ${DB_PORT_HOST}:${DB_PORT_CONT} \
  -v ${PREFIX}-data:/var/lib/mysql \
  mariadb:11

echo "=== Запускаем приложение ==="
docker run -d \
  --name ${PREFIX}-web \
  --add-host host.docker.internal:host-gateway \
  -e APP_PORT=${APP_PORT_CONT} \
  -e DATABASE_URL="mysql://root:lab@host.docker.internal:${DB_PORT_HOST}/lab" \
  -p ${APP_PORT_HOST}:${APP_PORT_CONT} \
  ${PREFIX}/probe:${IMAGE_VER}

echo "=== Ждём готовности базы (до 60 сек) ==="
SECONDS=0
until curl -sf -m 3 localhost:${APP_PORT_HOST}/notes > /dev/null || [ $SECONDS -ge 60 ]; do
  sleep 2
done
curl -s localhost:${APP_PORT_HOST}/notes
echo
