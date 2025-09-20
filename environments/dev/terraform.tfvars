project_name = "microservices"
environment  = "dev"
aws_region   = "ap-south-1"

# Network Configuration
vpc_cidr               = "10.0.0.0/16"
availability_zones     = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
public_subnet_cidrs    = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
private_subnet_cidrs   = ["10.0.10.0/24", "10.0.20.0/24", "10.0.30.0/24"]
database_subnet_cidrs  = ["10.0.100.0/24", "10.0.101.0/24", "10.0.102.0/24"]

# Database Configuration
db_name     = "microservices_dev"
db_username = "dbadmin"
# db_password should be set via environment variable or secrets manager

# Resource Tags
tags = {
  Project     = "Microservices"
  Environment = "dev"
  ManagedBy   = "Terraform"
  CostCenter  = "Engineering"
  Owner       = "DevOps Team"
}
