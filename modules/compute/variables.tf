variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "Security group ID for the ALB"
  type        = string
}

variable "ecs_security_group_id" {
  description = "Security group ID for ECS tasks"
  type        = string
}

variable "ecr_repository_web" {
  description = "ECR repository URL for the web app"
  type        = string
}

variable "ecr_repository_admin" {
  description = "ECR repository URL for the admin API"
  type        = string
}

variable "db_endpoint" {
  description = "RDS endpoint address"
  type        = string
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_password_secret_arn" {
  description = "ARN of the Secrets Manager secret for DB password"
  type        = string
}

variable "tags" {
  description = "Map of tags to apply"
  type        = map(string)
}
