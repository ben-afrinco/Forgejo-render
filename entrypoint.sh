#!/bin/sh
set -e

echo "=== Starting Forgejo on Render Free Tier ==="

mkdir -p /data/gitea/conf /data/git /data/lfs

export FORGEJO__server__ROOT_URL="https://${RENDER_EXTERNAL_HOSTNAME}"
export FORGEJO__server__DOMAIN="${RENDER_EXTERNAL_HOSTNAME}"
export FORGEJO__server__SSH_DOMAIN="${RENDER_EXTERNAL_HOSTNAME}"

export FORGEJO__database__DB_TYPE=postgres
export FORGEJO__database__HOST="${FORGEJO_DB_HOST}"
export FORGEJO__database__NAME="${FORGEJO_DB_NAME}"
export FORGEJO__database__USER="${FORGEJO_DB_USER}"
export FORGEJO__database__PASSWD="${FORGEJO_DB_PASSWORD}"
export FORGEJO__database__SSL_MODE="${FORGEJO_DB_SSLMODE}"
export FORGEJO__database__MAX_OPEN_CONNS=5
export FORGEJO__database__MAX_IDLE_CONNS=2

export FORGEJO__server__DISABLE_SSH=true
export FORGEJO__server__START_SSH_SERVER=false
export FORGEJO__server__LFS_START_SERVER=false

export FORGEJO__security__INSTALL_LOCK=true
export FORGEJO__service__DISABLE_REGISTRATION=true
export FORGEJO__service__REQUIRE_SIGNIN_VIEW=false

export FORGEJO__session__PROVIDER=db
export FORGEJO__cache__ADAPTER=memory
export FORGEJO__cache__INTERVAL=60

export FORGEJO__log__MODE=console
export FORGEJO__log__LEVEL=Warn

export FORGEJO__repository__DISABLE_STARS=true
export FORGEJO__repository__DISABLE_FORKS=true
export FORGEJO__mirror__ENABLED=false
export FORGEJO__api__ENABLE_SWAGGER=false
export FORGEJO__actions__ENABLED=false
export FORGEJO__packages__ENABLED=false
export FORGEJO__federation__ENABLED=false
export FORGEJO__picture__DISABLE_GRAVATAR=true
export FORGEJO__picture__ENABLE_FEDERATED_AVATAR=false

export GOMEMLIMIT=400MiB
export GOGC=50

echo "=== Starting Forgejo on Render Free Tier ==="

mkdir -p /data/gitea/conf /data/git /data/lfs

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

# ✅ استبدال القيم — Alpine يحتاج sed -i.bak (وليس sed -i فقط)
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

# حذف النسخ الاحتياطية
rm -f /data/gitea/conf/app.ini.bak

export GOMEMLIMIT=400MiB
export GOGC=50

echo "Launching Forgejo..."
exec /usr/local/bin/forgejo web
