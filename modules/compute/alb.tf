# Application Load Balancer
resource "aws_lb" "main" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_security_group_id]
  subnets           = var.public_subnet_ids

  enable_deletion_protection = false

  tags = var.tags
}

# Target Groups
resource "aws_lb_target_group" "web_app" {
  name        = "${var.project_name}-web-app-tg"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    path                = "/health"
    matcher             = "200"
    port                = "traffic-port"
    protocol            = "HTTP"
  }

  tags = var.tags
}

resource "aws_lb_target_group" "admin_api" {
  name        = "${var.project_name}-admin-api-tg"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    path                = "/health"
    matcher             = "200"
    port                = "traffic-port"
    protocol            = "HTTP"
  }

  tags = var.tags
}

# Listeners
resource "aws_lb_listener" "web" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_app.arn
  }
}

resource "aws_lb_listener_rule" "admin_api" {
  listener_arn = aws_lb_listener.web.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.admin_api.arn
  }

  condition {
    path_pattern {
      values = ["/api/admin/*"]
    }
  }
}
resource "aws_lb_listener" "admin" {
  load_balancer_arn = aws_lb.main.arn
  port              = 81
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.admin_api.arn
  }
}

