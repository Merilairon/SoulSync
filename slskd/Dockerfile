ARG BUILD_FROM=slskd/slskd:latest
FROM ${BUILD_FROM}

# Switch to root so we can write the entrypoint script
USER root

COPY run.sh /run.sh
RUN chmod +x /run.sh

ENTRYPOINT ["/run.sh"]
