#!/bin/bash

# Define ANSI color codes for colorful output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Environment variables for (S3) access
S3_ENDPOINT=$S3_ENDPOINT
S3_ACCESS_KEY=$S3_ACCESS_KEY
S3_SECRET_KEY=$S3_SECRET_KEY
S3_BUCKET=$S3_BUCKET
S3_PATH=$S3_PATH

# Check if S3 config variables are set
if [ -z "$S3_ENDPOINT" ] || [ -z "$S3_ACCESS_KEY" ] || [ -z "$S3_SECRET_KEY" ] || [ -z "$S3_BUCKET" ]; then
    echo -e "${RED}S3 configuration is incomplete. Please set all required environment variables.${NC}"
    exit 1
fi

echo -e "${GREEN}Starting DHCP Backup${NC}"
SOURCE_LEASE_FILE="/dhcpd/leases/dhcpd.leases"
SOURCE_CONFIG_FILE="/dhcpd/config/dhcpd.conf"

# Archive and compress lease and config files
CURRENT_DATETIME=$(date +"%Y-%m-%d_%H-%M-%S")
echo -e "${YELLOW}Current Time: $CURRENT_DATETIME${NC}"
ARCHIVE_NAME="dhcp_backup_$CURRENT_DATETIME.tar.gz"
tar -czf $ARCHIVE_NAME $SOURCE_LEASE_FILE $SOURCE_CONFIG_FILE
echo -e "${GREEN}Archive created: $ARCHIVE_NAME${NC}"

# Perform the upload using curl with TLS verification disabled
echo -e "${YELLOW}Uploading $ARCHIVE_NAME to S3...${NC}"
HTTP_STATUS=$(curl -X PUT --insecure -T "$ARCHIVE_NAME" \
               -H "Authorization: Bearer $(echo -n "$S3_ACCESS_KEY:$S3_SECRET_KEY" | base64)" \
               "$S3_ENDPOINT/$S3_BUCKET$S3_PATH$ARCHIVE_NAME" \
               -o /dev/null -w '%{http_code}')

if [ "$HTTP_STATUS" -eq 200 ] || [ "$HTTP_STATUS" -eq 201 ]; then
    echo -e "${GREEN}Upload to S3 successful.${NC}"
else
    echo -e "${RED}Upload to S3 failed with status: $HTTP_STATUS${NC}"
    exit 1
fi
