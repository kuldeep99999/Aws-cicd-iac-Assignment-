output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.main.name
}

output "web_app_service_name" {
  description = "ECS service name for the web app"
  value       = aws_ecs_service.web_app.name
}

output "admin_api_service_name" {
  description = "ECS service name for the admin API"
  value       = aws_ecs_service.admin_api.name
}

output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = aws_lb.main.arn
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.main.dns_name
}


output "alb_zone_id" {
  description = "Canonical Hosted Zone ID of the ALB"
  value       = aws_lb.main.zone_id
}
