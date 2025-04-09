### EventBridge Scheduler for Starting the DB Cluster ###
resource "aws_scheduler_schedule" "start_db_cluster" {
  count = var.enable_db_scheduler ? 1 : 0

  name        = "${var.prefix}-start-db-cluster"
  description = "Schedule to start the Aurora DB cluster"

  flexible_time_window {
    mode = "OFF"
  }

  schedule_expression = var.db_start_schedule

  target {
    arn      = "arn:aws:scheduler:::aws-sdk:rds:startDBCluster"
    role_arn = aws_iam_role.eventbridge_scheduler_role[0].arn

    input = jsonencode({
      DbClusterIdentifier = aws_rds_cluster.bookshelf_db_cluster.id
    })
  }

  state = "ENABLED"
}

### EventBridge Scheduler for Stopping the DB Cluster ###
resource "aws_scheduler_schedule" "stop_db_cluster" {
  count = var.enable_db_scheduler ? 1 : 0

  name        = "${var.prefix}-stop-db-cluster"
  description = "Schedule to stop the Aurora DB cluster"

  flexible_time_window {
    mode = "OFF"
  }

  schedule_expression = var.db_stop_schedule

  target {
    arn      = "arn:aws:scheduler:::aws-sdk:rds:stopDBCluster"
    role_arn = aws_iam_role.eventbridge_scheduler_role[0].arn

    input = jsonencode({
      DbClusterIdentifier = aws_rds_cluster.bookshelf_db_cluster.id
    })
  }

  state = "ENABLED"
}
