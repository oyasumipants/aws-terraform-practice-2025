# ECS Task Execution Role
resource "aws_iam_role" "ecs_task_execution" {
  name = "${var.app_name}-${var.environment}-ecs-task-execution"

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

  tags = merge(
    {
      Name        = "${var.app_name}-${var.environment}-ecs-task-execution"
      Environment = var.environment
    },
    var.tags
  )
}

# ECS Task Execution Role Policy
resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ECS Task Role
resource "aws_iam_role" "ecs_task" {
  name = "${var.app_name}-${var.environment}-ecs-task"

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

  tags = merge(
    {
      Name        = "${var.app_name}-${var.environment}-ecs-task"
      Environment = var.environment
    },
    var.tags
  )
}

# ECS Task Role CloudWatch Logs Policy
resource "aws_iam_policy" "ecs_task_logs" {
  name = "${var.app_name}-${var.environment}-ecs-task-logs"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })

  tags = merge(
    {
      Name        = "${var.app_name}-${var.environment}-ecs-task-logs"
      Environment = var.environment
    },
    var.tags
  )
}

resource "aws_iam_role_policy_attachment" "ecs_task_logs" {
  role       = aws_iam_role.ecs_task.name
  policy_arn = aws_iam_policy.ecs_task_logs.arn
}

# Policy for accessing secrets
resource "aws_iam_policy" "ecs_task_secrets" {
  name = "${var.app_name}-${var.environment}-ecs-task-secrets"

  count = var.database_secret_arn != "" ? 1 : 0

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = var.database_secret_arn
      }
    ]
  })

  tags = merge(
    {
      Name        = "${var.app_name}-${var.environment}-ecs-task-secrets"
      Environment = var.environment
    },
    var.tags
  )
}

# Attach secrets policy to ECS task execution role if database_secret_arn is provided
resource "aws_iam_role_policy_attachment" "ecs_task_secrets" {
  count      = var.database_secret_arn != "" ? 1 : 0
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = aws_iam_policy.ecs_task_secrets[0].arn
}
