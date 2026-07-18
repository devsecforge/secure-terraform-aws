# ⚠️  INTENTIONALLY INSECURE — FOR CONTRAST/TRAINING ONLY. DO NOT APPLY.
# tfsec and checkov should flag every issue commented below. This file is
# excluded from the plan/apply flow and exists purely to show what "bad" looks like.

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
}

provider "aws" {
  region = "us-east-1"
}

# ❌ Public, unencrypted, unversioned bucket with a wide-open policy.
resource "aws_s3_bucket" "bad" {
  bucket = "devsecforge-insecure-example"
}

resource "aws_s3_bucket_acl" "bad" {
  bucket = aws_s3_bucket.bad.id
  acl    = "public-read"          # ❌ world-readable
}

# ❌ No public-access block, no encryption, no versioning, no TLS-only policy.

# ❌ Wildcard admin IAM policy — the classic over-privilege mistake.
resource "aws_iam_policy" "admin" {
  name = "devsecforge-insecure-admin"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "*"                 # ❌ every action
      Resource = "*"                 # ❌ every resource
    }]
  })
}

# ❌ Security group open to the world on SSH.
resource "aws_security_group" "open" {
  name = "devsecforge-insecure-sg"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]      # ❌ SSH open to the entire internet
  }
}
