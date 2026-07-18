# IAM Least-Privilege Guide

The most common — and most damaging — cloud misconfiguration is over-privileged IAM. This guide
captures the rules this repo follows.

## The rules
1. **No wildcards in production policies.** Never `Action: "*"` or `Resource: "*"`.
2. **Scope to specific ARNs.** Grant access to *this* bucket, not *all* buckets.
3. **Separate read from write.** A reader role gets `GetObject`/`ListBucket` — never `PutObject`/`DeleteObject`.
4. **Split KMS usage from KMS management.** Apps get `kms:Decrypt`; they don't get `kms:*`.
5. **Prefer roles over long-lived users/keys.** Assume-role with a trust policy scoped to the service.
6. **One role per workload.** Don't share a role across services.

## Good vs bad

```hcl
# ✅ GOOD — scoped, read-only
actions   = ["s3:GetObject", "s3:ListBucket"]
resources = [bucket_arn, "${bucket_arn}/*"]

# ❌ BAD — the anti-pattern in examples/insecure
actions   = ["*"]
resources = ["*"]
```

## How to verify
- `checkov` flags `CKV_AWS_*` for wildcard policies.
- `tfsec` rule `aws-iam-no-policy-wildcards` catches `*` actions.
- Review the generated `policy` JSON in `terraform plan` before applying.

## Escalating privileges safely
Start from *zero* and add exactly the actions an app fails without — read the AWS error, grant that
one action, repeat. It's slower than `"*"` and it's the difference between a contained incident and
a full account compromise.
