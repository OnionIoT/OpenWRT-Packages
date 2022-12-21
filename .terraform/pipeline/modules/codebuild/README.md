<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 2.7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 2.7.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.step_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_codebuild_project.step_build_project](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project) | resource |
| [aws_iam_policy.service_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.service_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.service_role_policy_attachement](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_policy_document.codebuild_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_build_step"></a> [build\_step](#input\_build\_step) | Name of the step related to the codebuild project | `string` | n/a | yes |
| <a name="input_buildspec_file"></a> [buildspec\_file](#input\_buildspec\_file) | Buildspec file name or code. | `string` | n/a | yes |
| <a name="input_cache_bucket"></a> [cache\_bucket](#input\_cache\_bucket) | Bucket name used for caching | `string` | `null` | no |
| <a name="input_codebuild_role_policy_json"></a> [codebuild\_role\_policy\_json](#input\_codebuild\_role\_policy\_json) | Policy document of codebuild iam role | `string` | n/a | yes |
| <a name="input_compute_type"></a> [compute\_type](#input\_compute\_type) | CodeBuild Compute instance type | `string` | `"BUILD_GENERAL1_SMALL"` | no |
| <a name="input_environment_variables"></a> [environment\_variables](#input\_environment\_variables) | Additional environment variables to add | `map(string)` | `{}` | no |
| <a name="input_is_privileged_mode"></a> [is\_privileged\_mode](#input\_is\_privileged\_mode) | Is privileged mode, used if docker is needed | `bool` | `false` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Projet Name | `string` | n/a | yes |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | sensitive environment variables to add | `map(string)` | `{}` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | Deployment stage | `string` | n/a | yes |
| <a name="input_step_description"></a> [step\_description](#input\_step\_description) | Description of the step related to the codebuild project | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Resources tags | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_codebuild_project"></a> [aws\_codebuild\_project](#output\_aws\_codebuild\_project) | n/a |
<!-- END_TF_DOCS -->