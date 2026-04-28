# dev/remote-state/terragrunt.hcl

include "root" {
  path = find_in_parent_folders("root.hcl")
}

inputs = {
  environment = "dev"
  aws_region  = "us-east-1"
  app         = "sk-demo"
  profile     = "karim"
}
