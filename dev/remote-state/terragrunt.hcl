generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"

  contents = <<EOF
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "karim"
}
EOF
}

terraform {
  source = "../../modules/remote-state"
}

inputs = {
  environment = "dev"
  aws_region  = "us-east-1"
  app         = "sk-demo"
  profile     = "karim"
}