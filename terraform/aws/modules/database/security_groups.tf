resource "aws_security_group" "bookshelf_db_cluster_sg" {
  name        = "${var.prefix}-bookshelf-db-cluster-sg"
  description = "Security group for bookshelf db cluster"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = var.private_subnet_cidrs
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = merge(
    {
      Name        = "${var.prefix}-bookshelf-db-cluster-sg"
      Environment = var.environment
    },
    var.tags
  )
}

