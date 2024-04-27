#!/bin/bash

# Define ANSI color codes for colorful output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

DHCP_CONFIG_FILE=/dhcpd/config/dhcpd.conf

# Check if the DHCP config file exists
if [ ! -f "$DHCP_CONFIG_FILE" ]; then
    echo -e "${RED}Configuration file not found${NC}"
    echo -e "${YELLOW}Running in Development Mode${NC}"
    DHCP_CONFIG_FILE=/dhcpd/config/default.conf
else
    echo -e "${GREEN}Configuration file found.${NC}"
fi

# Initialize the counter
count=0

# Wait for the leases file to exist, checking every 5 seconds
while [ ! -f "/dhcpd/leases/dhcpd.leases" ] && [ $count -lt 20 ]; do
    echo -e "${YELLOW}Waiting for leases file to be created... (Attempt $((count + 1))/${NC}"
    sleep 5
    ((count++))
done

if [ ! -f "/dhcpd/leases/dhcpd.leases" ]; then
    echo -e "${RED}Lease file not found after 20 attempts, creating a blank leases file...${NC}"
    touch /dhcpd/leases/dhcpd.leases
else
    echo -e "${GREEN}Leases file found, starting DHCP server...${NC}"
fi

# Start DHCP server
exec /usr/sbin/dhcpd -4 -d -cf $DHCP_CONFIG_FILE -lf /dhcpd/leases/dhcpd.leases
