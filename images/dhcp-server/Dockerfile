FROM debian:latest

## Perform Upgrade to Base image
RUN apt-get update && apt-get install -y isc-dhcp-server iproute2 \
    && rm -rf /var/lib/apt/lists/*

## Create the Following Directories
RUN mkdir /dhcpd/ \
    && mkdir /dhcpd/leases/ \
    && mkdir /dhcpd/config/

# Copy Entrypoint Script and DHCP configuration files
COPY scripts/entrypoint.sh /dhcpd/entrypoint.sh
COPY config/* /dhcpd/config/

# Set permissions for the entrypoint script
RUN chmod +x /dhcpd/entrypoint.sh

EXPOSE 67/udp

# Set the entrypoint
ENTRYPOINT ["/dhcpd/entrypoint.sh"]