# Helper variables
V = 0
Q = $(if $(filter 1,$V),,@)
M = $(shell printf "\033[34;1m▶\033[0m")

default: help

.PHONY: build
build: ## Building blog
build: ; $(info $(M) building blog)
	$(Q) cd blog && npm run build

.PHONY: install
install: ## Installing dependencies
install: ; $(info $(M) installing dependencies)
	$(Q) cd blog && npm install

.PHONY: help
help: ## shows this help message
	$(Q) awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n\nTargets:\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m\t %s\n", $$1, $$2 }' $(MAKEFILE_LIST)
