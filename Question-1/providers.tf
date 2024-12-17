terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.81.0"
    }
  }
}


provider "aws" {
  region = var.region  # Update this to your preferred AWS region
}