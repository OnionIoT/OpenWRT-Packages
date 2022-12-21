locals {
  code_start_connection_id = split("/", aws_codestarconnections_connection.github_connection.id)[1]
}

output "Github_connection_url" {
  value       = "https://${var.region}.console.aws.amazon.com/codesuite/settings/${data.aws_caller_identity.current.account_id}/${var.region}/connections/${local.code_start_connection_id}"
  description = "Connection url for code star to link Code pipeline to Github app"
}


output "artifacts_bucket" {
  value       = aws_s3_bucket.codepipeline_bucket.bucket
  description = "Bucket name for artifacts. (used also for cache)"
}
