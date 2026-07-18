variable "region" {
  description = "AWS region to deploy into."
  type        = string
  default     = "us-east-1"
}

variable "name_prefix" {
  description = "Prefix for resource names (must be globally unique for S3)."
  type        = string
  default     = "devsecforge-demo"
}
