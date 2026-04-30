################################################################################
# Data Source — current AWS account
################################################################################

data "aws_caller_identity" "current" {}



################################################################################
# IAM Role for Terraform State Access (S3 + KMS)
################################################################################

resource "aws_iam_role" "terraform_state_access" {
  name        = "${var.environment}-${var.app}-state-access-role"
  description = "Role assumed by Terragrunt to access S3 state and KMS"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowAssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${var.profile}"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

################################################################################
# IAM Policy for Terraform State Access (S3 + KMS)
################################################################################

resource "aws_iam_policy" "terraform_state_access" {
  name        = "${var.environment}-${var.app}-terraform-state-access"
  description = "Allows Terraform/Terragrunt to read, write, and lock state in S3 using use_lockfile=true"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "StateFileAccess"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = "${module.state_bucket.s3_bucket_arn}/*"
      },
      {
        Sid      = "StateBucketList"
        Effect   = "Allow"
        Action   = "s3:ListBucket"
        Resource = module.state_bucket.s3_bucket_arn
      },
      {
        Sid    = "KMSAccess"
        Effect = "Allow"
        Action = [
          "kms:GenerateDataKey",
          "kms:Decrypt"
        ]
        Resource = module.kms_key.key_arn
      }
    ]
  })

  tags = {
    Name        = "${var.environment}-${var.app}-terraform-state-access"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

################################################################################
# Attach Policy to Role
################################################################################

resource "aws_iam_role_policy_attachment" "terraform_state_access" {
  role       = aws_iam_role.terraform_state_access.name
  policy_arn = aws_iam_policy.terraform_state_access.arn
}