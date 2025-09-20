variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "alb_dns_name" {
  description = "DNS name of the ALB origin"
  type        = string
}

variable "tags" {
  description = "Map of tags to apply"
  type        = map(string)
}
