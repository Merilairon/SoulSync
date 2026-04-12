#!/bin/bash
# slskd – Home Assistant Addon Entrypoint
# Reads options from /data/options.json (provided by HA Supervisor) and starts slskd.

set -e

echo "🔍 slskd (Soulseek) Home Assistant Addon Starting..."

# ── Read options ──────────────────────────────────────────────────────────────
OPTIONS_FILE="/data/options.json"

if [ -f "${OPTIONS_FILE}" ]; then
    API_KEY=$(jq -r '.api_key // "change-me"' "${OPTIONS_FILE}")
    TIMEZONE=$(jq -r '.timezone // "Europe/Brussels"' "${OPTIONS_FILE}")
    REMOTE_CFG=$(jq -r '.remote_configuration // true' "${OPTIONS_FILE}")
else
    API_KEY="change-me"
    TIMEZONE="Europe/Brussels"
    REMOTE_CFG="true"
fi

echo "  Timezone             : ${TIMEZONE}"
echo "  Remote configuration : ${REMOTE_CFG}"
echo "  API key set          : $([ "${API_KEY}" != 'change-me' ] && echo yes || echo '⚠ still default — change it!')"

# ── Directories ───────────────────────────────────────────────────────────────
# /data            → addon-private (slskd config, database, incomplete downloads)
# /share/soulsync/downloads → shared with the SoulSync addon
mkdir -p \
    /data/slskd \
    /share/soulsync/downloads

# ── Environment passed to slskd ───────────────────────────────────────────────
export TZ="${TIMEZONE}"
export SLSKD_APP_DIR=/data/slskd           # store config/db in addon-private volume
export SLSKD_DOWNLOADS_DIR=/share/soulsync/downloads  # shared with SoulSync
export SLSKD_API_KEY="${API_KEY}"
export SLSKD_REMOTE_CONFIGURATION="${REMOTE_CFG}"

echo ""
echo "🚀 Starting slskd on port 5030..."
exec /app/slskd "$@"
