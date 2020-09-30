resource "aws_codebuild_project" "project" {
  name         = "twitter-counter-api-build-and-deploy"
  description  = "build and deploy via Serverless Framework"
  service_role = aws_iam_role.codebuild_service_role.arn

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
    # TODO: env
    buildspec = "buildspec.yml"
  }
}
