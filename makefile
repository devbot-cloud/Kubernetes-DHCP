# Define default values for variables, allow override from environment
REPO ?= docker.io/library
TAG ?= latest
DHCP_SERVER_TAG ?= $(REPO)/dhcp-server:$(TAG)
DHCP_BACKUP_TAG ?= $(REPO)/dhcp-backup:$(TAG)

.PHONY: all build-dhcp-server build-dhcp-backup

# Default target that builds both images
all: build-dhcp-server build-dhcp-backup

# Target to build DHCP Server Docker image
build-dhcp-server:
	@echo "Building DHCP Server Docker image..."
	docker build -t $(DHCP_SERVER_TAG) ./images/dhcp-server
	@echo "DHCP Server image built successfully with tag $(DHCP_SERVER_TAG)."

# Target to build DHCP Backup Docker image
build-dhcp-backup:
	@echo "Building DHCP Backup Docker image..."
	docker build -t $(DHCP_BACKUP_TAG) ./images/dhcp-backup
	@echo "DHCP Backup image built successfully with tag $(DHCP_BACKUP_TAG)."
