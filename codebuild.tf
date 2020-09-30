module "codebuild_staging" {
  source           = "./modules/codebuild"
  stage            = "staging"
  service_role_arn = aws_iam_role.codebuild_service_role.arn
}

module "codebuild_production" {
  source           = "./modules/codebuild"
  stage            = "production"
  service_role_arn = aws_iam_role.codebuild_service_role.arn
}
