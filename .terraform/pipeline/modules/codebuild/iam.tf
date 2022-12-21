resource "aws_iam_policy" "service_role_policy" {
  name        = "${var.project_name}-codebuild-policy-${var.build_step}-${var.stage}"
  description = "CodeBuild service role"
  policy      = var.codebuild_role_policy_json
}

data "aws_iam_policy_document" "codebuild_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "service_role" {
  name               = "${var.project_name}-codebuild-role-${var.build_step}-${var.stage}"
  assume_role_policy = data.aws_iam_policy_document.codebuild_assume_role.json
  tags               = var.tags
}

resource "aws_iam_role_policy_attachment" "service_role_policy_attachement" {
  role       = aws_iam_role.service_role.name
  policy_arn = aws_iam_policy.service_role_policy.arn
}
