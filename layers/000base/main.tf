###############################################################################
# Providers
###############################################################################
provider "aws" {
  region = "ap-southeast-2"
}

###############################################################################
# Terraform config
###############################################################################
terraform {
  required_version = ">= 1.3.0, < 2.0.0"
  required_providers {
    aws = {
      source  = "registry.terraform.io/hashicorp/aws"
      version = ">= 4.59.0"
    }
  }
    backend "s3" {
    bucket  = "state-bucket-for-terraform-demo-XXXXXX"
    key     = "terraform.000base.tfstate"
    region  = "ap-southeast-2"
    encrypt = "true"
  }
}

###############################################################################
# VPC
###############################################################################
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.1"

  name = "demo-vpc"
  azs  = ["ap-southeast-2a", "ap-southeast-2b", "ap-southeast-2c"]
  cidr = "10.0.0.0/16"
  
  private_subnets  = ["10.0.0.0/20", "10.0.16.0/20", "10.0.32.0/20"]
  public_subnets   = ["10.0.48.0/24", "10.0.49.0/24", "10.0.50.0/24"]
  database_subnets = ["10.0.58.0/24", "10.0.59.0/24", "10.0.60.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  enable_dns_hostnames = true
  enable_dns_support   = true
}
