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

echo "Launching Forgejo..."
exec /usr/local/bin/forgejo web
