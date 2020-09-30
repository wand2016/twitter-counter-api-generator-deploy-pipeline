resource "aws_s3_bucket" "pipeline" {
  bucket        = "twitter-counter-api-deploy-pipeline-artifacts"
  acl           = "private"
  force_destroy = false
}
