data "aws_iam_policy_document" "build_image_action_role_policy_document" {
  statement {
    actions = [
      "cloudwatch:*",
      "codebuild:*",
      "logs:*",
      "s3:*",
      "codestar-connections:UseConnection"
    ]
    resources = ["*"]
  }
}

data "local_file" "buildspec_image_local" {
  filename = "${path.module}/buildspec/buildspec-build-image.yml"
}

module "build_image_action" {
  source           = "./modules/codebuild"
  project_name     = var.project_name
  step_description = "CodeBuild Project for: ${local.stage} stage: Build Image"
  stage            = local.stage
  tags             = local.tags

  codebuild_role_policy_json = data.aws_iam_policy_document.build_image_action_role_policy_document.json
  environment_variables      = local.tf_codebuild_env_vars
  secrets                    = local.codebuild_shared_secrets
  build_step                 = "image"
  buildspec_file             = data.local_file.buildspec_image_local.content
  cache_bucket               = aws_s3_bucket.codepipeline_bucket.bucket
}
