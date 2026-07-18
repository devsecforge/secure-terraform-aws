<div align="center">

# 🔐 secure-terraform-aws

**Secure-by-default Terraform for AWS — hardened modules, least-privilege IAM, and a `tfsec` + `checkov` policy gate in CI. The easy path is the secure path.**

[![Terraform Security](https://github.com/devsecforge/secure-terraform-aws/actions/workflows/terraform-security.yml/badge.svg)](https://github.com/devsecforge/secure-terraform-aws/actions/workflows/terraform-security.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
![Terraform](https://img.shields.io/badge/Terraform-7B42BC?logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-232F3E?logo=amazonwebservices&logoColor=white)
![tfsec](https://img.shields.io/badge/tfsec-4B275F?logo=aqua&logoColor=white)

</div>

---

## 📖 Overview

Most cloud breaches trace back to a handful of misconfigurations: public buckets, missing
encryption, and over-privileged IAM. This repo makes those mistakes **hard to make** — a module
that can't create an insecure bucket, an IAM pattern scoped to exact ARNs, and a CI gate
(`tfsec` + `checkov`) that fails the build on any regression. An intentionally-insecure example is
included to show — and scan — the anti-patterns.

## ✨ Features

- 🪣 **`secure-s3` module** — public-access block, SSE-KMS/AES256, versioning, TLS-only policy, logging.
- 🔑 **KMS with rotation** — customer-managed key, 30-day deletion window.
- 🪪 **Least-privilege IAM** — read-only role scoped to one bucket + `kms:Decrypt` only. No wildcards.
- 🚦 **Policy-as-code gate** — `terraform fmt/validate` + `tfsec` + `checkov` → SARIF to the Security tab.
- ⚠️ **Insecure counter-example** — documented anti-patterns, excluded from gating.

## 🖼️ Screenshots

> _Placeholder — capture when you run it:_
> - `docs/img/checkov-pass.png` — Checkov passing on the secure baseline
> - `docs/img/security-tab.png` — findings from the insecure example in the Security tab

## 🏛️ Architecture

Full diagram in **[docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)**.

```
KMS (rotation) → data bucket (SSE-KMS, versioned, TLS-only, logged) → log bucket
                 least-privilege IAM role (read-only, this bucket + kms:Decrypt)
                 CI: fmt · validate · tfsec · checkov → SARIF
```

## ⚙️ Installation

**Prerequisites:** `terraform >= 1.5`. For scans: `tfsec`, `checkov`. (AWS creds only if you `plan/apply`.)

```bash
git clone https://github.com/devsecforge/secure-terraform-aws.git
cd secure-terraform-aws
```

## 🚀 Usage

```bash
make fmt        # format
make validate   # init + validate the secure baseline (no AWS creds needed)
make scan       # tfsec + checkov locally (mirrors CI)
make plan       # terraform plan (requires AWS credentials)
```

Use the module in your own code:
```hcl
module "data_bucket" {
  source      = "github.com/devsecforge/secure-terraform-aws//modules/secure-s3"
  bucket_name = "my-org-app-data-prod"
  kms_key_arn = aws_kms_key.data.arn
  tags        = { Environment = "prod" }
}
```

## 📁 Folder Structure

```
secure-terraform-aws/
├── modules/secure-s3/            # hardened, reusable S3 module (+ README)
├── examples/
│   ├── secure-baseline/          # KMS + data/log buckets + least-priv IAM role
│   └── insecure/                 # ⚠️ intentionally insecure (excluded from gating)
├── policies/checkov/.checkov.yaml
├── scripts/scan.sh               # local tfsec + checkov (mirrors CI)
├── docs/
│   ├── ARCHITECTURE.md · THREAT_MODEL.md · IAM-LEAST-PRIVILEGE.md
├── .github/workflows/terraform-security.yml
├── Makefile
└── SECURITY · CONTRIBUTING · CODE_OF_CONDUCT · CHANGELOG · LICENSE
```

## 🧰 Technology Stack

`Terraform` · `AWS` (S3, KMS, IAM) · `tfsec` · `checkov` · `GitHub Actions`

## 🔐 Security & Threat Model

Reporting: **[SECURITY.md](SECURITY.md)**. STRIDE analysis: **[docs/THREAT_MODEL.md](docs/THREAT_MODEL.md)**.
IAM guidance: **[docs/IAM-LEAST-PRIVILEGE.md](docs/IAM-LEAST-PRIVILEGE.md)**.

## 🗺️ Roadmap

- [ ] `secure-vpc` module (private subnets, flow logs)
- [ ] Cross-region replication example
- [ ] OPA/Conftest gate alongside tfsec/checkov
- [ ] Pre-commit hooks (fmt, tflint)

## ❓ FAQ

<details><summary><b>Do I need an AWS account to try this?</b></summary>
No — <code>make validate</code> and <code>make scan</code> run with no credentials. You only need
AWS creds to <code>terraform plan/apply</code>.</details>

<details><summary><b>Why keep an insecure example in the repo?</b></summary>
To demonstrate the anti-patterns and prove the scanners catch them. It lives in
<code>examples/insecure/</code> and is excluded from the gating scan.</details>

## 🤝 Contributing

See **[CONTRIBUTING.md](CONTRIBUTING.md)** and the **[Code of Conduct](CODE_OF_CONDUCT.md)**.

## 📄 License

[MIT](LICENSE) © 2026 devsecforge

---

<div align="center"><sub>Part of an open DevSecOps portfolio. ⭐ Star it if it's useful.</sub></div>
