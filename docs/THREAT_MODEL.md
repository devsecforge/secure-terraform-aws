# Threat Model — AWS Data Storage Baseline

STRIDE analysis for the S3 + KMS + IAM baseline in `examples/secure-baseline`.

## Assets
- Data stored in the S3 bucket
- The KMS encryption key
- IAM credentials / roles that can access the data

## Trust boundaries
1. Internet → S3 API
2. AWS principal (role/user) → S3 / KMS
3. Application (EC2) → assumed IAM role

## STRIDE

| Threat | Scenario | Control |
|--------|----------|---------|
| **S**poofing | Anonymous request reads the bucket | Public-access block + bucket policy; no ACLs |
| **T**ampering | Object overwritten/deleted maliciously | Versioning enabled; write not granted to reader role |
| **R**epudiation | No record of who accessed data | S3 access logging to a separate bucket |
| **I**nfo disclosure | Data intercepted in transit / at rest | TLS-only policy (deny `aws:SecureTransport=false`) + SSE-KMS |
| **D**enial of service | Key deleted, data unrecoverable | 30-day KMS deletion window; versioning |
| **E**levation of privilege | Over-broad IAM grants lateral access | Least-privilege role: read-only, single bucket, `kms:Decrypt` only |

## Anti-patterns demonstrated (in `examples/insecure`)
- `public-read` ACL, no encryption, no versioning
- `Action: "*" / Resource: "*"` IAM policy
- Security group with `0.0.0.0/0` on port 22

Each is flagged by tfsec/checkov — the point of keeping them in the repo.

## Residual / out of scope
- Cross-account access patterns, VPC endpoints, and Organizations SCPs.
- Backup/replication (roadmap: cross-region replication example).
