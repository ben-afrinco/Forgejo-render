#!/bin/sh
set -e

echo "=== Starting Forgejo on Render Free Tier ==="

mkdir -p /data/gitea/conf /data/git /data/lfs

export FORGEJO_CUSTOM=/data/gitea
export GITEA_WORK_DIR=/data
export FORGEJO_WORK_DIR=/data

cat > /data/gitea/conf/app.ini << 'EOF'
[security]
INSTALL_LOCK = true
SECRET_KEY = __SECRET_KEY__
INTERNAL_TOKEN = __INTERNAL_TOKEN__

[server]
ROOT_URL = __ROOT_URL__
DOMAIN = __DOMAIN__
SSH_DOMAIN = __SSH_DOMAIN__
HTTP_PORT = 3000
PROTOCOL = http
DISABLE_SSH = true
START_SSH_SERVER = false
LFS_START_SERVER = false

[database]
DB_TYPE = postgres
HOST = __DB_HOST__
NAME = __DB_NAME__
USER = __DB_USER__
PASSWD = __DB_PASSWD__
SSL_MODE = __DB_SSLMODE__
MAX_OPEN_CONNS = 5
MAX_IDLE_CONNS = 2

[service]
DISABLE_REGISTRATION = true
REQUIRE_SIGNIN_VIEW = false

[session]
PROVIDER = db

[cache]
ADAPTER = memory
INTERVAL = 60

[log]
MODE = console
LEVEL = Warn

[repository]
DISABLE_STARS = true
DISABLE_FORKS = true

[mirror]
ENABLED = false

[api]
ENABLE_SWAGGER = false

[actions]
ENABLED = false

[packages]
ENABLED = false

[federation]
ENABLED = false

[picture]
DISABLE_GRAVATAR = true
ENABLE_FEDERATED_AVATAR = false
EOF

sed -i.bak "s|__SECRET_KEY__|${FORGEJO__security__SECRET_KEY}|g" /data/gitea/conf/app.ini
sed -i.bak "s|__INTERNAL_TOKEN__|${FORGEJO__security__INTERNAL_TOKEN}|g" /data/gitea/conf/app.ini
sed -i.bak "s|__ROOT_URL__|https://${RENDER_EXTERNAL_HOSTNAME}|g" /data/gitea/conf/app.ini
sed -i.bak "s|__DOMAIN__|${RENDER_EXTERNAL_HOSTNAME}|g" /data/gitea/conf/app.ini
sed -i.bak "s|__SSH_DOMAIN__|${RENDER_EXTERNAL_HOSTNAME}|g" /data/gitea/conf/app.ini
sed -i.bak "s|__DB_HOST__|${FORGEJO_DB_HOST}|g" /data/gitea/conf/app.ini
sed -i.bak "s|__DB_NAME__|${FORGEJO_DB_NAME}|g" /data/gitea/conf/app.ini
sed -i.bak "s|__DB_USER__|${FORGEJO_DB_USER}|g" /data/gitea/conf/app.ini
sed -i.bak "s|__DB_PASSWD__|${FORGEJO_DB_PASSWORD}|g" /data/gitea/conf/app.ini
sed -i.bak "s|__DB_SSLMODE__|${FORGEJO_DB_SSLMODE}|g" /data/gitea/conf/app.ini
rm -f /data/gitea/conf/app.ini.bak

export GOMEMLIMIT=400MiB
export GOGC=50

echo "Launching Forgejo..."
exec /usr/local/bin/forgejo web --config /data/gitea/conf/app.ini
