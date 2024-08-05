# Global variables
REPO_NAME = docukube
IMAGE_VERSION = "latest"
BASE_IMAGE_TAG = "base:latest"
IMAGE_USER_ID = "101"

# Find all directories in the build folder
BUILD_DIRS := $(shell find build -maxdepth 1 -type d | tail -n +2)

# Convert directories to build and run targets with appropriate prefixes
BUILD_TARGETS := $(addprefix build-, $(notdir $(BUILD_DIRS)))
RUN_TARGETS := $(addprefix run-, $(notdir $(BUILD_DIRS)))

# Install all needed dependencies
install-dependencies:
	@echo "Installing dependencies"
	# Install kubectl if it doesn't exist
	@if ! command -v kubectl &> /dev/null; then \
		curl -LO "https://dl.k8s.io/release/$(shell curl --silent --location https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"; \
		chmod +x kubectl; \
		sudo mv kubectl /usr/local/bin/; \
	fi
	# Check if docker is installed
	@if ! command -v docker &> /dev/null; then \
		echo "Docker is not installed. Please install Docker before proceeding."; \
		exit 1; \
	fi

# Build base image
build-base:
	@echo "Building base image"
	@docker build --build-arg IMAGE_USER_ID=$(IMAGE_USER_ID) -t $(REPO_NAME)/$(BASE_IMAGE_TAG) base

# Pattern rule to build individual images
$(BUILD_TARGETS): build-%: build-base
	@echo "Building image in build/$*"
	@docker build --build-arg BASE_IMAGE=$(REPO_NAME)/$(BASE_IMAGE_TAG) -t $(REPO_NAME)/$*:$(IMAGE_VERSION) build/$*

# Build all images in the build folder
build-images: $(BUILD_TARGETS)

# Pattern rule to run individual images
$(RUN_TARGETS): run-%:
	@echo "Running image $(REPO_NAME)/$*"
	@docker run --rm -it -p 8080:8080 $(REPO_NAME)/$*:$(IMAGE_VERSION)

# Test the Kubernetes code using kustomize
test-kubernetes: install-dependencies
	@echo "Building and applying Kubernetes code using kustomize"
	@kustomize build deploy

# # Perform Kubernetes linting
# TODO - Add kubeval to the Dockerfile
# lint_kubernetes: install_dependencies
	@echo "Performing Kubernetes linting"
	@kubeval deploy/*.yaml

clean:
	@echo "Cleaning all images related to the repository"
	@docker images --filter=reference="$(REPO_NAME)/*" -q | xargs -r docker rmi -f

# Build all images
build: build-base build-images

# Default target
all: install-dependencies build test-kubernetes

# Print all build and run targets (for debugging)
print_targets:
	@echo "Build targets: $(BUILD_TARGETS)"
	@echo "Run targets: $(RUN_TARGETS)"