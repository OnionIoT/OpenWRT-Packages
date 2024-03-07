project_name      = "openwrt"
region            = "us-east-1"
deployment_bucket = "devops-openwrt-terraform-state-ezops-test-download"

stage_vars = {
  "prod" = {
    branch = "prod"
  }
}
