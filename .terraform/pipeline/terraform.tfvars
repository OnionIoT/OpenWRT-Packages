project_name      = "openwrt"
region            = "us-east-1"
deployment_bucket = "repo.onioniot.com"

stage_vars = {
  "prod" = {
    branch = "prod"
  }
  "devops" = {
    branch = "devops"
  }
}
