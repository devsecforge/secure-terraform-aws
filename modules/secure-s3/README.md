# Module: `secure-s3`

A hardened S3 bucket, secure by default. Passes `tfsec` and `checkov` with no suppressions.

## Controls
| Control | Resource |
|---------|----------|
| Block all public access | `aws_s3_bucket_public_access_block` |
| Encryption at rest (KMS or AES256) | `aws_s3_bucket_server_side_encryption_configuration` |
| Versioning | `aws_s3_bucket_versioning` |
| TLS-only (deny insecure transport) | `aws_s3_bucket_policy` |
| Optional access logging | `aws_s3_bucket_logging` |

## Usage
```hcl
module "data_bucket" {
  source      = "../../modules/secure-s3"
  bucket_name = "my-org-app-data-prod"
  kms_key_arn = aws_kms_key.data.arn        # optional; omit for SSE-S3
  tags        = { Environment = "prod" }
}
```

## Inputs
| Name | Type | Default | Required |
|------|------|---------|----------|
| `bucket_name` | string | — | yes |
| `kms_key_arn` | string | `null` | no |
| `logging_target_bucket` | string | `null` | no |
| `tags` | map(string) | `{}` | no |

## Outputs
`bucket_id` · `bucket_arn` · `bucket_domain_name`
