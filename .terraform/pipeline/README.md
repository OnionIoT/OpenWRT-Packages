<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.60.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.45.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_build_image_action"></a> [build\_image\_action](#module\_build\_image\_action) | ./modules/codebuild | n/a |
| <a name="module_build_packages_action"></a> [build\_packages\_action](#module\_build\_packages\_action) | ./modules/codebuild | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_codepipeline.codepipeline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codepipeline) | resource |
| [aws_codestarconnections_connection.github_connection](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codestarconnections_connection) | resource |
| [aws_iam_policy.codepipeline_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.codepipeline_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.service_role_policy_attachement](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_s3_bucket.codepipeline_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.build_image_action_role_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.build_packages_action_role_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.codepipeline_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.codepipeline_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_deployment_bucket"></a> [deployment\_bucket](#input\_deployment\_bucket) | Deployment Bucket to host the packages and images | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Deployment project name: will be used as prefix for resources | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `"us-east-1"` | no |
| <a name="input_stage_vars"></a> [stage\_vars](#input\_stage\_vars) | Stage Specific Variables | <pre>map(<br>    object({<br>      branch = string<br>    })<br>  )</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_Github_connection_url"></a> [Github\_connection\_url](#output\_Github\_connection\_url) | Connection url for code star to link Code pipeline to Github app |
| <a name="output_artifacts_bucket"></a> [artifacts\_bucket](#output\_artifacts\_bucket) | Bucket name for artifacts. (used also for cache) |
<!-- END_TF_DOCS -->