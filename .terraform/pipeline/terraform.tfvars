project_name      = "openwrt"
region            = "us-east-1"
deployment_bucket = "devops-openwrt-terraform-ezops-test-download"

# Set the buildspec file name. Options include 'development-buildspec.yml' for development or 'buildspec.yml' for production.
buildspec_file_name = "buildspec.yml"

stage_vars = {
  "prod" = {
    branch = "release"
  }
}
