variable "bucket_name" {
  description = "Globally-unique S3 bucket name."
  type        = string
}

variable "kms_key_arn" {
  description = "Optional KMS key ARN for SSE-KMS. If null, SSE-S3 (AES256) is used."
  type        = string
  default     = null
}

variable "logging_target_bucket" {
  description = "Optional bucket name to receive S3 server access logs."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags applied to the bucket."
  type        = map(string)
  default     = {}
}
