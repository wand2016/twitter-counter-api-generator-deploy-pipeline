variable "stage" {
  default = "dev"
  description = "staging or production"
}
variable "bucket_name" {
  default = "dev-twitter-counter-api"
  description = "staging or production"
}
variable "cache_bucket_name" {
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

  cache {
    type     = "S3"
    location = var.cache_bucket_name
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

    environment_variable {
      name = "STAGE"
      value = var.stage
    }

    environment_variable {
      name = "AWS_BUCKET"
      value = var.bucket_name
    }

  }

  source {
    type = "CODEPIPELINE"
    buildspec = "buildspec.yml"
  }
}

output "codebuild_project_name" {
  value = aws_codebuild_project.default.name
}
