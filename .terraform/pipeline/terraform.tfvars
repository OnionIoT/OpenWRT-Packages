project_name      = "openwrt"
region            = "us-east-1"
deployment_bucket = "devops-openwrt-terraform-ezops-test-download"

stage_vars = {
  "prod" = {
    branch = "prod"
  }
}
