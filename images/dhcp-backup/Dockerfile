FROM debian:latest

# Update Base Image, Install tar/curl
RUN apt-get update && \
    apt-get install -y curl tar && \
    rm -rf /var/lib/apt/lists/* \
    && useradd -m -s /bin/bash backupuser \
    && mkdir /backup

# Use backupuser
USER backupuser
WORKDIR /backup

# Copy the backup script
COPY --chown=backupuser:1000 scripts/entrypoint.sh /backup/entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["/backup/entrypoint.sh"]