locals {
  cloudwatch_log_group_name = "${var.project_name}-codebuild-${var.build_step}-${var.stage}"
}

resource "aws_cloudwatch_log_group" "step_log_group" {
  name = local.cloudwatch_log_group_name
  tags = var.tags
}

resource "aws_codebuild_project" "step_build_project" {
  name         = "${var.project_name}-codebuild-${var.build_step}-${var.stage}"
  description  = var.step_description
  service_role = aws_iam_role.service_role.arn
  tags         = var.tags


  dynamic "cache" {
    for_each = var.cache_bucket != null ? [true] : []
    content {
      type     = "S3"
      location = "${var.cache_bucket}/cache/archive"
    }
  }

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type    = var.compute_type
    image           = "aws/codebuild/standard:7.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = var.is_privileged_mode
    dynamic "environment_variable" {
      for_each = merge(
        var.environment_variables,
        {
          stage      = var.stage,
          build_step = var.build_step
        }
      )
      content {
        name  = environment_variable.key
        value = environment_variable.value
        type  = "PLAINTEXT"
      }
    }

    dynamic "environment_variable" {
      for_each = var.secrets
      content {
        name  = environment_variable.key
        value = environment_variable.value
        type  = "SECRETS_MANAGER"
      }
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = var.buildspec_file
  }

  logs_config {
    cloudwatch_logs {
      status     = "ENABLED"
      group_name = local.cloudwatch_log_group_name
    }
  }
}
