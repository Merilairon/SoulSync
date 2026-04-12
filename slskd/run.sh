#!/bin/bash
# slskd – Home Assistant Addon Entrypoint
# Reads options from /data/options.json (provided by HA Supervisor) and starts slskd.
# Uses only grep/sed — no jq required.

set -e

# Helper: extract a string value from flat JSON without jq
json_get() {
    grep -o "\"$1\" *: *\"[^\"]*\"" "${OPTIONS_FILE}" 2>/dev/null \
        | sed 's/.*: *"\(.*\)"/\1/' \
        | head -1
}

# Helper: extract a boolean/number value from flat JSON without jq
json_get_raw() {
    grep -o "\"$1\" *: *[^,}]*" "${OPTIONS_FILE}" 2>/dev/null \
        | sed 's/.*: *//' \
        | tr -d ' ' \
        | head -1
}

echo "🔍 slskd (Soulseek) Home Assistant Addon Starting..."

OPTIONS_FILE="/data/options.json"

if [ -f "${OPTIONS_FILE}" ]; then
    API_KEY=$(json_get "api_key")
    TIMEZONE=$(json_get "timezone")
    REMOTE_CFG=$(json_get_raw "remote_configuration")
    # Apply defaults for missing keys
    API_KEY="${API_KEY:-change-me}"
    TIMEZONE="${TIMEZONE:-Europe/Brussels}"
    REMOTE_CFG="${REMOTE_CFG:-true}"
else
    API_KEY="change-me"
    TIMEZONE="Europe/Brussels"
    REMOTE_CFG="true"
fi

echo "  Timezone             : ${TIMEZONE}"
echo "  Remote configuration : ${REMOTE_CFG}"
echo "  API key set          : $([ "${API_KEY}" != 'change-me' ] && echo yes || echo '⚠ still default — change it!')"

# ── Directories ───────────────────────────────────────────────────────────────
mkdir -p \
    /data/slskd \
    /share/soulsync/downloads

# ── Environment passed to slskd ───────────────────────────────────────────────
export TZ="${TIMEZONE}"
export SLSKD_APP_DIR=/data/slskd
export SLSKD_DOWNLOADS_DIR=/share/soulsync/downloads
export SLSKD_API_KEY="${API_KEY}"
export SLSKD_REMOTE_CONFIGURATION="${REMOTE_CFG}"

echo ""
echo "🚀 Starting slskd on port 5030..."
exec /app/slskd "$@"
