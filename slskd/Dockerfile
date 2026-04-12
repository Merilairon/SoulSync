ARG BUILD_FROM=slskd/slskd:latest
FROM ${BUILD_FROM}

# Switch to root to install jq (image may run as non-root)
USER root

RUN apt-get update \
    && apt-get install -y --no-install-recommends jq \
    && rm -rf /var/lib/apt/lists/*

COPY run.sh /run.sh
RUN chmod +x /run.sh

ENTRYPOINT ["/run.sh"]
