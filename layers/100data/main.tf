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
    bucket  = "state-bucket-for-terraform-demo-vyzkrg"
    key     = "terraform.100data.tfstate"
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
    bucket  = "state-bucket-for-terraform-demo-vyzkrg"
    key     = "terraform.000base.tfstate"
    region  = "ap-southeast-2"
    encrypt = "true"
  }
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
# Security Groups (RDS)
###############################################################################
module "security_group_rds" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.1"

  name        = "RDS-SG"
  description = "RDS Security Group"
  vpc_id      = local.vpc_id

  ingress_with_cidr_blocks = [
    {
      rule        = "postgresql-tcp"
      cidr_blocks = local.vpc_cidr
    },
  ]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

}

###############################################################################
# RDS Subnet Group
###############################################################################
resource "aws_db_subnet_group" "database" {
  name        = "rds-subnet-group"
  description = "Database subnet group for RDS"
  subnet_ids  = local.database_subnets

}

###############################################################################
# RDS
###############################################################################
module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "6.5.2"

  identifier = "rds-demo"

  engine               = "postgres"
  engine_version       = "14"
  family               = "postgres14"
  major_engine_version = "14"
  instance_class       = "db.t3.small"

  allocated_storage     = 20
  max_allocated_storage = 100

  db_name                = "demo"
  username               = "demoUser"
  password               = "demoPassword123"
  port                   = 5432

  publicly_accessible         = false
  manage_master_user_password = false

  multi_az               = false
  db_subnet_group_name   = aws_db_subnet_group.database.name
  vpc_security_group_ids = [module.security_group_rds.security_group_id]

  backup_retention_period = 1
  skip_final_snapshot     = true
  deletion_protection     = false

}
