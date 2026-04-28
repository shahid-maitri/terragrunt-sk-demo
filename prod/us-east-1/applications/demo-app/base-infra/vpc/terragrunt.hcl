
include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "vpc_common" {
  path   = "${get_repo_root()}/_envcommon/vpc.hcl"
  expose = true
}

inputs = {
  vpc_cidr =  "10.1.0.0/16"
}