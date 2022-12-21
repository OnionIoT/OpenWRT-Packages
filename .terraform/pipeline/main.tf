
data "aws_caller_identity" "current" {}

locals {
  stage      = terraform.workspace
  stage_vars = var.stage_vars[local.stage]
  tags = {
    ProjectName = var.project_name
    Stage       = local.stage
    Scope       = "pipeline"
  }

  repositories = {
    packages      = "OnionIoT/OpenWRT-Packages"
    image_builder = "OnionIoT/openwrt-imagebuilder-wrapper"
    sdk           = "OnionIoT/openwrt-sdk-wrapper"
  }

  tf_codebuild_env_vars = {
    stage         = local.stage
    REGION        = var.region
    OUTPUT_BUCKET = var.deployment_bucket
  }

  codebuild_shared_secrets = {
  }
}

resource "aws_codestarconnections_connection" "github_connection" {
  name          = "${var.project_name}-connection-${local.stage}"
  provider_type = "GitHub"
}


resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = "devops-${var.project_name}-artifacts-${local.stage}"
  tags   = local.tags
}

resource "aws_codepipeline" "codepipeline" {
  name     = "${var.project_name}-pipeline-${local.stage}"
  role_arn = aws_iam_role.codepipeline_role.arn
  tags     = local.tags

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source-Trigger"

    action {
      name             = "Packages-source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["packages_source_output"]


      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.github_connection.arn
        FullRepositoryId = local.repositories.packages
        BranchName       = local.stage_vars.branch
      }
    }


    action {
      name             = "SDK-Wrapper-source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["sdk_source_output"]


      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.github_connection.arn
        FullRepositoryId = local.repositories.sdk
        BranchName       = local.stage_vars.branch
        DetectChanges    = false
      }
    }

    action {
      name             = "Image-builder-source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["image_builder_source_output"]


      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.github_connection.arn
        FullRepositoryId = local.repositories.image_builder
        BranchName       = local.stage_vars.branch
        DetectChanges    = false
      }
    }
  }

  stage {
    name = "Build-Packages"

    action {
      name = "Build-Packages"

      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["sdk_source_output"]
      output_artifacts = ["build_packages_output"]
      version          = "1"

      configuration = {
        ProjectName   = module.build_packages_action.aws_codebuild_project
        PrimarySource = "sdk_source_output"
      }
    }
  }


  stage {
    name = "Build-Image"

    action {
      name = "Build-Image"

      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["image_builder_source_output"]
      output_artifacts = ["build_images_output"]
      version          = "1"

      configuration = {
        ProjectName   = module.build_image_action.aws_codebuild_project
        PrimarySource = "image_builder_source_output"
      }
    }
  }

}

