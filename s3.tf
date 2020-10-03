resource "aws_s3_bucket" "pipeline" {
  bucket        = "twitter-counter-api-deploy-pipeline-artifacts"
  acl           = "private"
  force_destroy = true
}

resource "aws_s3_bucket" "build_cache" {
  bucket        = "twitter-counter-api-deploy-pipeline-caches"
  acl           = "private"
  force_destroy = true
}
