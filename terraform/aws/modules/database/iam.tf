### IAM Role for EventBridge Scheduler ###
resource "aws_iam_role" "eventbridge_scheduler_role" {
  count = var.enable_db_scheduler ? 1 : 0

  name = "${var.prefix}-eventbridge-scheduler-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "scheduler.amazonaws.com"
        }
      }
    ]
  })

  tags = merge({
    Name        = "${var.prefix}-eventbridge-scheduler-role"
    Environment = var.environment
  }, var.tags)
}

### IAM Policy for RDS Control ###
resource "aws_iam_policy" "rds_control_policy" {
  count = var.enable_db_scheduler ? 1 : 0

  name        = "${var.prefix}-rds-control-policy"
  description = "Policy to allow starting/stopping RDS clusters"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "rds:StartDBCluster",
          "rds:StopDBCluster",
          "rds:DescribeDBClusters"
        ]
        Effect   = "Allow"
        Resource = aws_rds_cluster.bookshelf_db_cluster.arn
      }
    ]
  })

  tags = merge({
    Name        = "${var.prefix}-rds-control-policy"
    Environment = var.environment
  }, var.tags)
}

### Attach the policy to the role ###
resource "aws_iam_role_policy_attachment" "attach_rds_control_policy" {
  count = var.enable_db_scheduler ? 1 : 0

  role       = aws_iam_role.eventbridge_scheduler_role[0].name
  policy_arn = aws_iam_policy.rds_control_policy[0].arn
} 