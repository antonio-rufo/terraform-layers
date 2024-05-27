###############################################################################
# Providers
###############################################################################
provider "aws" {
  region = "ap-southeast-2"
}

###############################################################################
# Terraform Config
###############################################################################
terraform {
  required_version = ">= 1.3.0, < 2.0.0"
  required_providers {
    aws = {
      source  = "registry.terraform.io/hashicorp/aws"
      version = ">= 4.59.0"
    }
  }
}

###############################################################################
# Random
###############################################################################
resource "random_string" "random" {
  length  = 6
  lower   = true
  upper   = false
  special = false
  numeric = false
}

###############################################################################
# S3 Bucket for Terraform state
###############################################################################
resource "aws_s3_bucket" "state" {
  bucket        = "state-bucket-for-terraform-demo-${random_string.random.result}"
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.state.id

  versioning_configuration {
    status = "Enabled"
  }
}