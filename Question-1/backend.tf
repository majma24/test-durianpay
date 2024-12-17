terraform {
  backend "s3" {
    bucket = "khalis-test"
    key    = "test-infra/terraform.tfstate"
    region = "ap-southeast-1"
  }
}