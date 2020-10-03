module "codebuild_staging" {
  source            = "./modules/codebuild"
  stage             = "staging"
  bucket_name       = "staging-twitter-counter-api"
  cache_bucket_name = aws_s3_bucket.build_cache.bucket
  service_role_arn  = aws_iam_role.codebuild_service_role.arn
}

module "codebuild_production" {
  source            = "./modules/codebuild"
  stage             = "production"
  bucket_name       = "twitter-counter-api"
  cache_bucket_name = aws_s3_bucket.build_cache.bucket
  service_role_arn  = aws_iam_role.codebuild_service_role.arn
}
