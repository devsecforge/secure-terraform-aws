# Contributing

Thanks for helping improve `secure-terraform-aws`!

## Ground rules
- Run `terraform fmt -recursive` before committing (CI checks formatting).
- New modules/examples must pass `tfsec` and `checkov` with **no suppressions**.
- Secure code goes in `modules/` and `examples/secure-baseline/`; intentionally-insecure teaching
  code goes in `examples/insecure/` with a clear warning comment.
- Run `./scripts/scan.sh` locally before opening a PR.
- Document new modules with a module-level README and an inputs/outputs table.

## Commit convention
[Conventional Commits](https://www.conventionalcommits.org/): `feat:`, `fix:`, `docs:`, `ci:`.

## PRs
Fill out the template, keep changes focused, ensure CI is green. Contributions are MIT-licensed.
