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
    key     = "terraform.200compute.tfstate"
    region  = "ap-southeast-2"
    encrypt = "true"
  }
}

###############################################################################
# Data Source
###############################################################################
data "terraform_remote_state" "base" {
  backend = "s3"

  config = {
    bucket  = "state-bucket-for-terraform-demo-XXXXXX"
    key     = "terraform.000base.tfstate"
    region  = "ap-southeast-2"
    encrypt = "true"
  }
}

data "terraform_remote_state" "data" {
  backend = "s3"

  config = {
    bucket  = "state-bucket-for-terraform-demo-XXXXXX"
    key     = "terraform.100data.tfstate"
    region  = "ap-southeast-2"
    encrypt = "true"
  }
}

data "aws_ami" "amazon-2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
  owners = ["amazon"]
}

###############################################################################
# Locals
###############################################################################
locals {
  vpc_id           = data.terraform_remote_state.base.outputs.vpc_id
  vpc_cidr         = data.terraform_remote_state.base.outputs.vpc_cidr
  private_subnets  = data.terraform_remote_state.base.outputs.private_subnets
  public_subnets   = data.terraform_remote_state.base.outputs.public_subnets
  database_subnets = data.terraform_remote_state.base.outputs.database_subnets

}

###############################################################################
# Security Groups (EC2 Instance)
###############################################################################
module "security_group_ec2" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.1"

  name        = "EC2-SG"
  description = "EC2 Security Group"
  vpc_id      = local.vpc_id

  ingress_with_cidr_blocks = [
    {
      rule        = "all-all"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

}

###############################################################################
# EC2 Instance (Grafana)
###############################################################################
module "ec2-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.6.1"

  depends_on = [module.security_group_ec2]

  name                   = "ec2-demo"
  ami                    = data.aws_ami.amazon-2.id
  instance_type          = "t2.small"
  subnet_id              = element(local.public_subnets, 0)
  vpc_security_group_ids = [module.security_group_ec2.security_group_id]

}

