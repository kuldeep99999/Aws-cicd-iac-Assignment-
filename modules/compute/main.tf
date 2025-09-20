data "aws_region" "current" {}

resource "aws_ecs_cluster" "main" {
  name = "${var.project_name}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = var.tags
}

resource "aws_ecs_cluster_capacity_providers" "main" {
  cluster_name = aws_ecs_cluster.main.name

  capacity_providers = ["FARGATE", "FARGATE_SPOT"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

resource "aws_ecs_task_definition" "web_app" {
  family                   = "${var.project_name}-web-app"
  requires_compatibilities = ["FARGATE"]
  network_mode            = "awsvpc"
  cpu                     = "256"
  memory                  = "512"
  execution_role_arn      = aws_iam_role.ecs_execution.arn
  task_role_arn          = aws_iam_role.ecs_task.arn

  container_definitions = jsonencode([
    {
      name  = "web-app"
      image = "${var.ecr_repository_web}:latest"
      
      portMappings = [
        {
          containerPort = 8080
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.web_app.name
          "awslogs-region"        = data.aws_region.current.name
          "awslogs-stream-prefix" = "ecs"
        }
      }

      secrets = [
        {
          name      = "DB_PASSWORD"
          valueFrom = var.db_password_secret_arn
        }
      ]

      environment = [
        {
          name  = "DB_HOST"
          value = var.db_endpoint
        },
        {
          name  = "DB_NAME"
          value = var.db_name
        }
      ]
    }
  ])

  tags = var.tags
}

resource "aws_ecs_task_definition" "admin_api" {
  family                   = "${var.project_name}-admin-api"
  requires_compatibilities = ["FARGATE"]
  network_mode            = "awsvpc"
  cpu                     = "256"
  memory                  = "512"
  execution_role_arn      = aws_iam_role.ecs_execution.arn
  task_role_arn          = aws_iam_role.ecs_task.arn

  container_definitions = jsonencode([
    {
      name  = "admin-api"
      image = "${var.ecr_repository_admin}:latest"
      
      portMappings = [
        {
          containerPort = 8080
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.admin_api.name
          "awslogs-region"        = data.aws_region.current.name
          "awslogs-stream-prefix" = "ecs"
        }
      }

      secrets = [
        {
          name      = "DB_PASSWORD"
          valueFrom = var.db_password_secret_arn
        }
      ]

      environment = [
        {
          name  = "DB_HOST"
          value = var.db_endpoint
        },
        {
          name  = "DB_NAME"
          value = var.db_name
        }
      ]
    }
  ])

  tags = var.tags
}

resource "aws_ecs_service" "web_app" {
  name            = "${var.project_name}-web-app"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.web_app.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.private_subnet_ids
    security_groups = [var.ecs_security_group_id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.web_app.arn
    container_name   = "web-app"
    container_port   = 8080
  }

  depends_on = [aws_lb_listener.web]

  tags = var.tags
}

resource "aws_ecs_service" "admin_api" {
  name            = "${var.project_name}-admin-api"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.admin_api.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.private_subnet_ids
    security_groups = [var.ecs_security_group_id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.admin_api.arn
    container_name   = "admin-api"
    container_port   = 8080
  }

  depends_on = [aws_lb_listener.admin]

  tags = var.tags
}

resource "aws_cloudwatch_log_group" "web_app" {
  name              = "/aws/ecs/${var.project_name}-web-app"
  retention_in_days = 7
  tags              = var.tags
}

resource "aws_cloudwatch_log_group" "admin_api" {
  name              = "/aws/ecs/${var.project_name}-admin-api"
  retention_in_days = 7
  tags              = var.tags
}

resource "aws_iam_role" "ecs_execution" {
  name = "${var.project_name}-ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "ecs_execution" {
  role       = aws_iam_role.ecs_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy" "ecs_secrets" {
  name = "${var.project_name}-ecs-secrets-policy"
  role = aws_iam_role.ecs_execution.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = [
          var.db_password_secret_arn
        ]
      }
    ]
  })
}

resource "aws_iam_role" "ecs_task" {
  name = "${var.project_name}-ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}
