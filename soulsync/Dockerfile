ARG BUILD_FROM=boulderbadgedad/soulsync:latest
FROM ${BUILD_FROM}

# Install jq for reading /data/options.json from HA Supervisor
RUN apt-get update \
    && apt-get install -y --no-install-recommends jq \
    && rm -rf /var/lib/apt/lists/*

# Copy Home Assistant–specific startup script
COPY run.sh /run.sh
RUN chmod +x /run.sh

# Replace the default entrypoint with our HA-compatible one
ENTRYPOINT ["/run.sh"]
