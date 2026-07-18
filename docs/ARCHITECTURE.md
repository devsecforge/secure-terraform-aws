# Architecture

`secure-terraform-aws` is a small, reusable **secure-by-default** Terraform baseline for AWS. The
philosophy: the *easy* path should also be the *secure* path — you shouldn't have to remember to add
encryption or block public access; the module does it for you, and CI proves it.

```
                 ┌──────────────────────────────────────────────┐
                 │            examples/secure-baseline           │
                 │                                              │
   KMS key ──────┼──▶  module.data_bucket (secure-s3)           │
  (rotation on)  │        · SSE-KMS · versioned · TLS-only      │
                 │        · public access blocked · logged ─────┼──▶ module.log_bucket
                 │                                              │
   IAM role ─────┼──▶  read-only, scoped to data bucket + kms:Decrypt only
 (least-priv)    │                                              │
                 └──────────────────────────────────────────────┘
                                    │
                       CI gate: fmt · validate · tfsec · checkov  →  SARIF → 🛡 Security tab
```

## Components
| Component | Security property |
|-----------|-------------------|
| `modules/secure-s3` | Public-access block, encryption, versioning, TLS-only policy, logging |
| KMS key | Customer-managed, **rotation enabled** |
| IAM role | Least privilege: `GetObject`/`ListBucket` on one bucket + `kms:Decrypt` only — no wildcards |
| CI | `terraform fmt/validate`, `tfsec`, `checkov` → SARIF |

## Design principles
- **Secure defaults, not secure options.** The module can't be created insecurely.
- **Least privilege everywhere.** No `*` actions/resources; scope to specific ARNs.
- **Prove it in CI.** Policy-as-code (tfsec + checkov) gates every change.
- **Teach by contrast.** `examples/insecure` shows the anti-patterns, excluded from gating.
