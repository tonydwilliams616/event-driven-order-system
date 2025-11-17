# -----------------------------
# Lambda Packaging Makefile
# -----------------------------

# Directory setup
LAMBDA_DIR := lambdas
DIST_DIR := $(LAMBDA_DIR)/.dist

# List all Lambda service folders
SERVICES := create_order payment_service inventory_service notification_service analytics_service

# Default target
.PHONY: all
all: clean build

# -----------------------------
# Clean everything
# -----------------------------
.PHONY: clean
clean:
	@echo "Cleaning build artifacts..."
	rm -rf $(DIST_DIR)
	find $(LAMBDA_DIR) -name "package.zip" -delete

# -----------------------------
# Build all services
# -----------------------------
.PHONY: build
build: $(SERVICES)

# -----------------------------
# Per-service build rule
# -----------------------------
$(SERVICES):
	@echo "Packaging Lambda: $@"
	mkdir -p $(DIST_DIR)/$@

	# If requirements.txt exists, install dependencies
	if [ -f $(LAMBDA_DIR)/$@/requirements.txt ]; then \
		pip install -r $(LAMBDA_DIR)/$@/requirements.txt --target $(DIST_DIR)/$@; \
	fi

	# Copy source files
	cp -r $(LAMBDA_DIR)/$@/*.py $(DIST_DIR)/$@/

	# Zip into package.zip
	cd $(DIST_DIR)/$@ && zip -r package.zip . > /dev/null

	# Move zip back into lambda folder
	mv $(DIST_DIR)/$@/package.zip $(LAMBDA_DIR)/$@/package.zip

	@echo "✓ Done: $(LAMBDA_DIR)/$@/package.zip"

# -----------------------------
# Build only one service (example)
# make package SERVICE=create_order
# -----------------------------
.PHONY: package
package:
	$(MAKE) $(SERVICE)