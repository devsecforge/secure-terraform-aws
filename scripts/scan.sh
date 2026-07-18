#!/usr/bin/env bash
# scan.sh — run the same Terraform security checks locally as CI.
# Usage: ./scripts/scan.sh
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"
blue() { printf '\033[0;34m%s\033[0m\n' "$*"; }
have() { command -v "$1" >/dev/null 2>&1; }

blue "== terraform fmt =="
if have terraform; then terraform fmt -check -recursive || echo "  (run: terraform fmt -recursive)"; else echo "  skip: terraform not installed"; fi

blue "== terraform validate (secure-baseline) =="
if have terraform; then (cd examples/secure-baseline && terraform init -backend=false -input=false >/dev/null && terraform validate); else echo "  skip"; fi

blue "== tfsec =="
if have tfsec; then tfsec . --exclude-path examples/insecure; else echo "  skip: tfsec not installed"; fi

blue "== checkov =="
if have checkov; then checkov -d . --config-file policies/checkov/.checkov.yaml; else echo "  skip: checkov not installed"; fi

blue "Done. (examples/insecure is expected to flag findings and is excluded from gating.)"
