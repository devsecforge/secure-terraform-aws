# secure-terraform-aws — entrypoints.
.DEFAULT_GOAL := help
SHELL := /bin/bash

.PHONY: help fmt validate scan plan

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2}'

fmt: ## Format all Terraform
	@terraform fmt -recursive

validate: ## Validate the secure-baseline example
	@cd examples/secure-baseline && terraform init -backend=false && terraform validate

scan: ## Run tfsec + checkov locally (mirrors CI)
	@bash scripts/scan.sh

plan: ## terraform plan for the secure-baseline (needs AWS creds)
	@cd examples/secure-baseline && terraform init && terraform plan
