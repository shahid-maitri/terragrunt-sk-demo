output "s3_bucket_id" {
  description = "S3 bucket ID for Terraform state"
  value       = module.state_bucket.s3_bucket_id
}

output "s3_bucket_arn" {
  description = "S3 bucket ARN"
  value       = module.state_bucket.s3_bucket_arn
}

output "kms_key_id" {
  description = "KMS key ID used for state encryption"
  value       = module.kms_key.key_id
}

output "kms_key_arn" {
  description = "KMS key ARN used for state encryption"
  value       = module.kms_key.key_arn
}

# output "dynamodb_table_name" {
#   description = "DynamoDB table name for state locking"
#   value       = aws_dynamodb_table.terraform_locks.name
# }

# output "dynamodb_table_arn" {
#   description = "DynamoDB table ARN"
#   value       = aws_dynamodb_table.terraform_locks.arn
# }

output "backend_config" {
  description = "Backend configuration to use in other modules"
  value = {
    bucket         = module.state_bucket.s3_bucket_id
    # dynamodb_table = aws_dynamodb_table.terraform_locks.name
    kms_key_id     = module.kms_key.key_id
  }
}
