resource "aws_codepipeline" "pipeline" {
  name     = "twitter-counter-api-deploy-pipeline"
  role_arn = aws_iam_role.codepipeline_service_role.arn

  artifact_store {
    location = aws_s3_bucket.pipeline.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        Owner = var.github_owner
        Repo  = var.github_repo
        # TODO: env?
        Branch               = "master"
        OAuthToken           = aws_ssm_parameter.github_personal_access_token.value
        PollForSourceChanges = "false"
      }
    }
  }

  stage {
    name = "Build-And-Deploy-Staging"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output_staging"]
      version          = "1"

      configuration = {
        ProjectName = module.codebuild_staging.codebuild_project_name
      }
    }
  }

  stage {
    name = "Build"

    action {
      name     = "Approval"
      category = "Approval"
      owner    = "AWS"
      provider = "Manual"
      version  = "1"
    }
  }

  stage {
    name = "Build-And-Deploy-Production"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output_production"]
      version          = "1"

      configuration = {
        ProjectName = module.codebuild_production.codebuild_project_name
      }
    }
  }
}

resource "aws_codepipeline_webhook" "webhook" {
  name            = "twitter-counter-api-deploy-pipeline-webhook"
  authentication  = "GITHUB_HMAC"
  target_action   = "Source"
  target_pipeline = aws_codepipeline.pipeline.name

  authentication_configuration {
    secret_token = aws_ssm_parameter.github_personal_access_token.value
  }

  filter {
    json_path    = "$.ref"
    match_equals = "refs/heads/{Branch}"
  }
}
