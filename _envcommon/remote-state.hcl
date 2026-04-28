# locals {
#   env_vars    = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
#   region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
#   app_vars    = read_terragrunt_config(find_in_parent_folders("app.hcl"))

#   environment = local.env_vars.locals.environment
#   aws_region  = local.region_vars.locals.aws_region
#   profile     = local.env_vars.locals.profile
#   app         = local.app_vars.locals.app_name
# }

# terraform {
#   source = "${dirname(find_in_parent_folders("root.hcl"))}/modules/remote-state"
# }

# inputs = {
#   environment = local.environment
#   aws_region  = local.aws_region
#   app         = local.app
#   profile     = local.profile
# }