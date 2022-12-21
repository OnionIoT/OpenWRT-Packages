variable "project_name" {
  description = "Projet Name"
  type        = string
}

variable "stage" {
  description = "Deployment stage"
  type        = string
}

variable "build_step" {
  description = "Name of the step related to the codebuild project"
  type        = string
}

variable "step_description" {
  description = "Description of the step related to the codebuild project"
  type        = string
}

variable "tags" {
  description = "Resources tags"
  type        = map(string)
}

variable "compute_type" {
  description = "CodeBuild Compute instance type"
  type        = string
  default     = "BUILD_GENERAL1_SMALL"
}

variable "codebuild_role_policy_json" {
  description = "Policy document of codebuild iam role"
  type        = string
}

variable "buildspec_file" {
  description = "Buildspec file name or code."
  type        = string
}

variable "environment_variables" {
  description = "Additional environment variables to add"
  type        = map(string)
  default     = {}
}

variable "secrets" {
  description = "sensitive environment variables to add"
  type        = map(string)
  default     = {}
}

variable "is_privileged_mode" {
  description = "Is privileged mode, used if docker is needed"
  type        = bool
  default     = false
}


variable "cache_bucket" {
  description = "Bucket name used for caching"
  type        = string
  default = null
}
