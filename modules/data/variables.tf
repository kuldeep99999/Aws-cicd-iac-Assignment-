variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "database_subnet_ids" {
  description = "List of subnet IDs for RDS"
  type        = list(string)
}

variable "db_security_group_id" {
  description = "Security group ID for RDS"
  type        = string
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_username" {
  description = "Database username"
  type        = string
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "tags" {
  description = "Map of tags to apply"
  type        = map(string)
}
