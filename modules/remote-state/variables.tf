variable "environment" {
  description = "Environment name (dev, prod, etc)"
  type        = string

  validation {
    condition     = contains(["dev", "prod", "staging", "qa"], var.environment)
    error_message = "Environment must be one of: dev, prod, staging, qa"
  }
}

variable "app" {
  description = "Application name"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.aws_region))
    error_message = "AWS region must be a valid region format (e.g., us-east-1)"
  }
}

variable "profile" {
  description = "AWS CLI profile to use"
  type        = string
}
