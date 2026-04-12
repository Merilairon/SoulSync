#!/bin/bash
# SoulSync – Home Assistant Addon Entrypoint
# Reads options from /data/options.json (provided by HA Supervisor) and starts SoulSync.

set -e

echo "🎵 SoulSync Home Assistant Addon Starting..."

# ── Read options from HA Supervisor ──────────────────────────────────────────
OPTIONS_FILE="/data/options.json"

if [ -f "${OPTIONS_FILE}" ]; then
    TIMEZONE=$(jq -r '.timezone // "Europe/Brussels"' "${OPTIONS_FILE}")
    LOG_LEVEL=$(jq -r '.log_level // "info"' "${OPTIONS_FILE}")
else
    TIMEZONE="Europe/Brussels"
    LOG_LEVEL="info"
fi

echo "  Timezone  : ${TIMEZONE}"
echo "  Log level : ${LOG_LEVEL}"

# ── Apply timezone ────────────────────────────────────────────────────────────
export TZ="${TIMEZONE}"

# ── Prepare persistent directories ───────────────────────────────────────────
# /data  → addon-private storage (config, database, logs)
# /share → HA shared storage (downloads land here for easy access)
# /media → HA media directory (organised music library destination)
mkdir -p \
    /data/config \
    /data/logs \
    /share/soulsync/downloads \
    /share/soulsync/staging \
    /media/soulsync

# ── Initialise config files ───────────────────────────────────────────────────
if [ ! -f /data/config/config.json ]; then
    echo "  📄 Creating default config.json from template..."
    cp /defaults/config.json /data/config/config.json
fi

# settings.py is application code — always refresh it to prevent stale versions
cp /defaults/settings.py /data/config/settings.py

# ── Auto-update yt-dlp ────────────────────────────────────────────────────────
echo "  🔄 Updating yt-dlp..."
pip install -U yt-dlp --quiet --no-cache-dir 2>/dev/null \
    && echo "  ✅ yt-dlp updated" \
    || echo "  ⚠️  yt-dlp update failed — using existing version"

# ── Environment ──────────────────────────────────────────────────────────────
export SOULSYNC_CONFIG_PATH=/data/config/config.json
export DATABASE_PATH=/data/music_library.db
export PYTHONPATH=/app
export PYTHONUNBUFFERED=1
export FLASK_APP=web_server.py
export FLASK_ENV=production

echo ""
echo "🚀 Starting SoulSync Web Server on port 8008..."
cd /app
exec python web_server.py
