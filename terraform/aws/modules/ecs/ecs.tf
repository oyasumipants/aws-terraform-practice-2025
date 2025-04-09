# ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = "${var.app_name}-${var.environment}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = merge(
    {
      Name        = "${var.app_name}-${var.environment}-cluster"
      Environment = var.environment
    },
    var.tags
  )
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "app" {
  name              = "/ecs/${var.app_name}-${var.environment}"
  retention_in_days = var.log_retention_days

  tags = merge(
    {
      Name        = "${var.app_name}-${var.environment}"
      Environment = var.environment
    },
    var.tags
  )
}

# ECS Task Definition
resource "aws_ecs_task_definition" "app" {
  family                   = "${var.app_name}-${var.environment}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  task_role_arn            = aws_iam_role.ecs_task.arn

  container_definitions = jsonencode([
    {
      name  = var.app_name
      image = "${var.ecr_repository_url}:${var.image_tag}"
      portMappings = [
        {
          containerPort = var.container_port
          protocol      = "tcp"
        }
      ]
      cpu         = var.cpu
      memory      = var.memory
      environment = []
      secrets = var.database_secret_arn != "" ? [
        {
          name      = "DATABASE_HOST"
          valueFrom = "${var.database_secret_arn}:host::"
        },
        {
          name      = "DATABASE_PASSWORD"
          valueFrom = "${var.database_secret_arn}:password::"
        }
      ] : []
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.app.name
          "awslogs-region"        = data.aws_region.current.name
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  tags = merge(
    {
      Name        = "${var.app_name}-${var.environment}"
      Environment = var.environment
    },
    var.tags
  )
}

# ECS Service
resource "aws_ecs_service" "app" {
  name                              = "${var.app_name}-${var.environment}"
  cluster                           = aws_ecs_cluster.main.id
  task_definition                   = aws_ecs_task_definition.app.arn
  desired_count                     = var.desired_count
  launch_type                       = "FARGATE"
  platform_version                  = "LATEST"
  health_check_grace_period_seconds = 60

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [aws_security_group.ecs_tasks.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app.arn
    container_name   = var.app_name
    container_port   = var.container_port
  }

  deployment_controller {
    type = "ECS"
  }

  # deployment_circuit_breaker {
  #   enable   = true
  #   rollback = true
  # }

  tags = merge(
    {
      Name        = "${var.app_name}-${var.environment}"
      Environment = var.environment
    },
    var.tags
  )

  # Uncomment if you need autoscaling.
  # lifecycle {
  #   ignore_changes = [desired_count]
  # }
}

# Get current region
data "aws_region" "current" {}
