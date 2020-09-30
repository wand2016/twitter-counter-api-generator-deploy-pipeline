terraform {
  required_version = ">= 0.13.3"
  backend "s3" {
    bucket  = "twitter-counter-api-generator-tfstate"
    region  = "ap-northeast-1"
    key     = "terraform.tfstate"
    encrypt = true
  }
}
