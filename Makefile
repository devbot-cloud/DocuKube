# Global variables
REPO_NAME = ghcr.io/devbot-cloud/docukube
IMAGE_VERSION = "0.1.4"
BASE_IMAGE_TAG = "base:$(IMAGE_VERSION)"
IMAGE_USER_ID = "101"
HELM_CHART_NAME = "docukube"
HELM_CHART_VERSION = "$(IMAGE_VERSION)"
HELM_REPO = $(REPO_NAME)
BUILD_DATE = $(shell date -u +'%Y-%m-%dT%H:%M:%SZ')
# Find all directories in the build folder
BUILD_DIRS := $(shell find build -maxdepth 1 -type d | tail -n +2)
# Convert directories to build and run targets with appropriate prefixes
BUILD_TARGETS := $(addprefix build-, $(notdir $(BUILD_DIRS)))
RUN_TARGETS := $(addprefix run-, $(notdir $(BUILD_DIRS)))

# Build base image
build-base:
	@echo "Building base image"
	@docker build --no-cache --build-arg IMAGE_USER_ID=$(IMAGE_USER_ID) --build-arg IMAGE_VERSION=$(IMAGE_VERSION) --build-arg BUILD_DATE=$(BUILD_DATE) -t $(REPO_NAME)/$(BASE_IMAGE_TAG) base

# Pattern rule to build individual images
$(BUILD_TARGETS): build-%: build-base
	@echo "Building image in build/$*"
	@docker build --build-arg BASE_IMAGE=$(REPO_NAME)/$(BASE_IMAGE_TAG) --build-arg IMAGE_VERSION=$(IMAGE_VERSION) --build-arg BUILD_DATE=$(BUILD_DATE) -t $(REPO_NAME)/$*:$(IMAGE_VERSION) build/$*

# Build all images in the build folder
build-images: $(BUILD_TARGETS)

# Pattern rule to run individual images
$(RUN_TARGETS): run-%:
	@echo "Running image $(REPO_NAME)/$*"
	@docker run --rm -it -p 8080:8080 $(REPO_NAME)/$*:$(IMAGE_VERSION)

# push all images
push-images: build
	@for dir in $(BUILD_DIRS); do \
		docker push $(REPO_NAME)/$$(basename $$dir):$(IMAGE_VERSION); \
	done
	
# Build Helm chart
helm-build:
	@echo "Building Helm chart"
	@helm package helm/$(HELM_CHART_NAME) --version $(HELM_CHART_VERSION) --destination .

helm-test:
	@echo "Testing Helm chart"
	@helm template $(HELM_CHART_NAME) helm/$(HELM_CHART_NAME) > /dev/null 2>&1

# Push Helm chart as OCI
helm-push: helm-build
	@echo "Pushing Helm chart as OCI"
	@helm push $(HELM_CHART_NAME)-$(HELM_CHART_VERSION).tgz oci://$(HELM_REPO)

# Build Everything 
build: build-base build-images

# Push Everything 
push: push-images helm-push

# Default target
all: install-dependencies build

# Print all build and run targets (for debugging)
print_targets:
	@echo "Build targets: $(BUILD_TARGETS)"
	@echo "Run targets: $(RUN_TARGETS)"

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
	# Install helm if it doesn't exist
	@if ! command -v helm &> /dev/null; then \
		curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash; \
	fi

clean:
	@echo "Cleaning all images related to the repository"
	@docker images --filter=reference="$(REPO_NAME)/*" -q | xargs -r docker rmi -f
	@rm -rf $(HELM_CHART_NAME)-$(HELM_CHART_VERSION).tgz