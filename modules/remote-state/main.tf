################################################################################
# KMS Key for S3 Encryption
################################################################################
# This module defines the resources needed to support other modules that use
# the Terraform S3 backend for remote state storage and state file locking.
#
# Resources:
# - KMS key for encrypting state bucket
# - S3 bucket for storing Terraform state files
# - DynamoDB table for implementing state file locking

module "kms_key" {
  source  = "terraform-aws-modules/kms/aws"
  version = "~> 2.1.0"

  description = "KMS key for encrypting Terraform backend state bucket"

  aliases = [
    "${var.aws_region}-${var.app}-tf-backend-key-${var.environment}-kms"
  ]

  tags = {
    Name        = "tf-backend-kms-${var.environment}"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

################################################################################
# S3 Bucket for Terraform State (with KMS Encryption)
################################################################################

module "state_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 4.6.0"

  bucket = "${var.app}-${var.environment}-${var.aws_region}-tf-state-bucket"

  versioning = {
    status = true
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = module.kms_key.key_arn
      }
      bucket_key_enabled = true
    }
  }

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  tags = {
    Name        = "tf-state-bucket-${var.environment}"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

################################################################################
# DynamoDB Table for State Locking
################################################################################

resource "aws_dynamodb_table" "terraform_locks" {
  name           = "${var.app}-${var.environment}-tf-lock-table"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "tf-lock-table-${var.environment}"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}