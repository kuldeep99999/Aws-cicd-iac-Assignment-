output "db_endpoint" {
  description = "RDS endpoint"
  value       = aws_db_instance.main.address
  sensitive   = true
}

output "db_password_secret_arn" {
  description = "ARN of the database password secret"
  value       = aws_secretsmanager_secret.db_password.arn
}
