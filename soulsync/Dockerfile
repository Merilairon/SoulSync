ARG BUILD_FROM=boulderbadgedad/soulsync:latest
FROM ${BUILD_FROM}

# Python (already in the base image) is used to parse /data/options.json — no extra deps needed.

# Copy Home Assistant–specific startup script
COPY run.sh /run.sh
RUN chmod +x /run.sh

# Replace the default entrypoint with our HA-compatible one
ENTRYPOINT ["/run.sh"]
