output "vpc_id" {
  description = "ID of the VPC"
  value       = module.network.vpc_id
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.compute.alb_dns_name
}

output "alb_zone_id" {
  description = "Zone ID of the Application Load Balancer"
  value       = module.compute.alb_zone_id
}

output "cloudfront_domain_name" {
  description = "Domain name of the CloudFront distribution"
  value       = module.edge.cloudfront_domain_name
}

output "cloudfront_distribution_id" {
  description = "ID of the CloudFront distribution"
  value       = module.edge.cloudfront_distribution_id
}

output "db_endpoint" {
  description = "Database endpoint"
  value       = module.data.db_endpoint
  sensitive   = true
}

output "ecr_web_app_url" {
  description = "ECR repository URL for web app"
  value       = aws_ecr_repository.web_app.repository_url
}

output "ecr_admin_api_url" {
  description = "ECR repository URL for admin API"
  value       = aws_ecr_repository.admin_api.repository_url
}

output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = module.compute.ecs_cluster_name
}

output "web_app_service_name" {
  description = "Name of the web app ECS service"
  value       = module.compute.web_app_service_name
}

output "admin_api_service_name" {
  description = "Name of the admin API ECS service"
  value       = module.compute.admin_api_service_name
}
