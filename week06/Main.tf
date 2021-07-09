terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

module "vpc" {
  source = "./vpc"
}

module "rds" {
  source = "./rds"

  private_subnet_1_id = module.vpc.private_subnet_1_id
  private_subnet_2_id = module.vpc.private_subnet_2_id
  VPC_id = module.vpc.VPC_id
}

module "messaging" {
  source = "./messaging"
}

module "dynamodb" {
  source = "./dynamodb"
}

module "ec2" {
  source = "./ec2"

  public_subnet_1_id = module.vpc.public_subnet_1_id
  public_subnet_2_id = module.vpc.public_subnet_2_id
  private_subnet_1_id = module.vpc.private_subnet_1_id
  private_subnet_2_id = module.vpc.private_subnet_2_id
  VPC_id = module.vpc.VPC_id
  rds_url = module.rds.rds_endpoint
}

module "route" {
  source = "./route"

  public_subnet_1_id = module.vpc.public_subnet_1_id
  public_subnet_2_id = module.vpc.public_subnet_2_id
  private_subnet_1_id = module.vpc.private_subnet_1_id
  private_subnet_2_id = module.vpc.private_subnet_2_id
  VPC_id = module.vpc.VPC_id
  NAT_id = module.ec2.NAT_id
}