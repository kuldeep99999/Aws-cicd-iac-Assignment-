terraform {
  required_version = ">= 1.5"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "microservices-terraform-state-dev-1"
    key            = "dev/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    dynamodb_table = "microservices-terraform-locks"
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = var.tags
  }
}

# Data sources
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# Network Module
module "network" {
  source = "../../modules/network"

  project_name            = var.project_name
  vpc_cidr               = var.vpc_cidr
  availability_zones     = var.availability_zones
  public_subnet_cidrs    = var.public_subnet_cidrs
  private_subnet_cidrs   = var.private_subnet_cidrs
  database_subnet_cidrs  = var.database_subnet_cidrs
  tags                   = var.tags
}

# Data Module
module "data" {
  source = "../../modules/data"

  project_name           = var.project_name
  database_subnet_ids    = module.network.database_subnet_ids
  db_security_group_id   = module.network.rds_security_group_id
  db_name               = var.db_name
  db_username           = var.db_username
  db_password           = var.db_password
  tags                  = var.tags
}

# ECR Repositories
resource "aws_ecr_repository" "web_app" {
  name                 = "${var.project_name}-web-app"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}

resource "aws_ecr_repository" "admin_api" {
  name                 = "${var.project_name}-admin-api"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}

# Compute Module
module "compute" {
  source = "../../modules/compute"

  project_name           = var.project_name
  vpc_id                = module.network.vpc_id
  public_subnet_ids     = module.network.public_subnet_ids
  private_subnet_ids    = module.network.private_subnet_ids
  alb_security_group_id = module.network.alb_security_group_id
  ecs_security_group_id = module.network.ecs_security_group_id
  
  ecr_repository_web    = aws_ecr_repository.web_app.repository_url
  ecr_repository_admin  = aws_ecr_repository.admin_api.repository_url
  
  db_endpoint           = module.data.db_endpoint
  db_name              = var.db_name
  db_password_secret_arn = module.data.db_password_secret_arn
  
  tags                  = var.tags
}

# Edge Module
module "edge" {
  source = "../../modules/edge"

  project_name = var.project_name
  alb_dns_name = module.compute.alb_dns_name
  tags         = var.tags
}
