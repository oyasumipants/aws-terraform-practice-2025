resource "random_password" "bookshelf_db_password" {
  length           = 20
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
  lifecycle {
    ignore_changes = [
      length,
      special,
      override_special
    ]
  }
}

resource "random_password" "bookshelf_db_write_user_password" {
  length           = 20
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
  lifecycle {
    ignore_changes = [
      length,
      special,
      override_special
    ]
  }
}

resource "aws_secretsmanager_secret" "bookshelf_db_password" {
  name = "/rds/bookshelf/bookshelf-password"

  tags = merge(
    {
      Name        = "bookshelf-db-password"
      Environment = var.environment
    },
    var.tags
  )
}

resource "aws_secretsmanager_secret_version" "bookshelf_db_password" {
  secret_id = aws_secretsmanager_secret.bookshelf_db_password.id
  secret_string = jsonencode({
    admin_username = var.master_username
    admin_password = random_password.bookshelf_db_password.result
    password       = random_password.bookshelf_db_write_user_password.result
    host           = aws_rds_cluster.bookshelf_db_cluster.endpoint
    port           = 3306
  })
  depends_on = [aws_rds_cluster.bookshelf_db_cluster]
}

resource "aws_db_subnet_group" "db_cluster_subnet_group" {
  name        = "${var.prefix}-db-cluster-subnet-group"
  description = "DB subnet group for Aurora"
  subnet_ids  = var.isolated_subnet_ids
}


resource "aws_rds_cluster" "bookshelf_db_cluster" {
  cluster_identifier = "${var.prefix}-bookshelf-db-cluster"
  engine             = "aurora-mysql"
  engine_version     = var.engine_version
  database_name      = "bookshelf"
  master_username    = var.master_username
  master_password    = random_password.bookshelf_db_password.result

  db_subnet_group_name   = aws_db_subnet_group.db_cluster_subnet_group.name
  vpc_security_group_ids = [aws_security_group.bookshelf_db_cluster_sg.id]

  backup_retention_period = var.backup_retention_period
  preferred_backup_window = var.preferred_backup_window
  skip_final_snapshot     = var.skip_final_snapshot

  tags = merge({
    Name = "${var.prefix}-bookshelf-db-cluster"
    },
    var.tags
  )
}

resource "aws_rds_cluster_instance" "bookshelf_db_cluster_instance" {
  count = var.instance_count

  identifier_prefix  = "${var.prefix}-bookshelf-db-${count.index + 1}"
  cluster_identifier = aws_rds_cluster.bookshelf_db_cluster.id
  instance_class     = var.instance_class
  engine             = aws_rds_cluster.bookshelf_db_cluster.engine
  engine_version     = aws_rds_cluster.bookshelf_db_cluster.engine_version


  db_subnet_group_name = aws_db_subnet_group.db_cluster_subnet_group.name

  tags = merge(
    {
      Name = "${var.prefix}-bookshelf-db-${count.index + 1}"
    },
    var.tags
  )
}
