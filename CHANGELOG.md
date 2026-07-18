# Changelog

Format based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/);
adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased]
### Planned
- `secure-vpc` module (private subnets, flow logs, no default SG rules)
- Cross-region replication example
- OPA/Conftest policy gate alongside tfsec/checkov
- Pre-commit hooks (terraform fmt, tflint)

## [1.0.0] - 2026-07-18
### Added
- `secure-s3` module: public-access block, SSE-KMS/AES256, versioning, TLS-only, logging.
- `secure-baseline` example: KMS (rotation on), logged data bucket, least-privilege IAM role.
- `insecure` example: documented anti-patterns for contrast (excluded from gating).
- CI: `terraform fmt/validate`, `tfsec`, `checkov` with SARIF upload.
- Docs: architecture, STRIDE threat model, IAM least-privilege guide.
- Governance: SECURITY, CONTRIBUTING, CODE_OF_CONDUCT, MIT license.
