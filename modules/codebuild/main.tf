variable "stage" {
  description = "staging or production"
}

variable "service_role_arn" {
}

resource "aws_codebuild_project" "default" {
  name         = "twitter-counter-api-build-and-deploy-${var.stage}"
  description  = "build and deploy via Serverless Framework"
  service_role = var.service_role_arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
  }

  source {
    type = "CODEPIPELINE"
    buildspec = "buildspec-${var.stage}.yml"
  }
}

output "codebuild_project_name" {
  value = aws_codebuild_project.default.name
}
