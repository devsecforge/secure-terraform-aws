# Secure baseline: a KMS-encrypted, access-logged data bucket, plus a least-privilege
# IAM role that can read ONLY that bucket. Demonstrates the module + IAM done right.

# ── KMS key with rotation enabled ────────────────────────────────
resource "aws_kms_key" "data" {
  description             = "${var.name_prefix} data encryption key"
  enable_key_rotation     = true
  deletion_window_in_days = 30
}

resource "aws_kms_alias" "data" {
  name          = "alias/${var.name_prefix}-data"
  target_key_id = aws_kms_key.data.key_id
}

# ── Access-log bucket (SSE-S3, private) ──────────────────────────
module "log_bucket" {
  source      = "../../modules/secure-s3"
  bucket_name = "${var.name_prefix}-access-logs"
  tags        = { Purpose = "access-logs" }
}

# ── Primary data bucket (SSE-KMS, versioned, logged) ─────────────
module "data_bucket" {
  source                = "../../modules/secure-s3"
  bucket_name           = "${var.name_prefix}-data"
  kms_key_arn           = aws_kms_key.data.arn
  logging_target_bucket = module.log_bucket.bucket_id
  tags                  = { Purpose = "app-data" }
}

# ── Least-privilege IAM role: read-only, scoped to the data bucket only ──
data "aws_iam_policy_document" "assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "reader" {
  name               = "${var.name_prefix}-data-reader"
  assume_role_policy = data.aws_iam_policy_document.assume.json
}

data "aws_iam_policy_document" "reader" {
  statement {
    sid     = "ReadDataBucketObjects"
    effect  = "Allow"
    actions = ["s3:GetObject", "s3:ListBucket"]        # no wildcards, no write/delete
    resources = [
      module.data_bucket.bucket_arn,
      "${module.data_bucket.bucket_arn}/*",
    ]
  }
  statement {
    sid       = "UseDataKmsKey"
    effect    = "Allow"
    actions   = ["kms:Decrypt"]                        # decrypt only, not manage
    resources = [aws_kms_key.data.arn]
  }
}

resource "aws_iam_role_policy" "reader" {
  name   = "${var.name_prefix}-data-reader-policy"
  role   = aws_iam_role.reader.id
  policy = data.aws_iam_policy_document.reader.json
}

output "data_bucket_arn" {
  value = module.data_bucket.bucket_arn
}

output "reader_role_arn" {
  value = aws_iam_role.reader.arn
}
