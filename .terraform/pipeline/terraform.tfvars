project_name      = "openwrt"
region            = "us-east-1"
deployment_bucket = "devops-openwrt-terraform-state-ezops-test-downloads"

stage_vars = {
  "prod" = {
    branch = "prod"
  }
  "openwrt-29.99" = {
    branch = "openwrt-29.99"
  }
}
