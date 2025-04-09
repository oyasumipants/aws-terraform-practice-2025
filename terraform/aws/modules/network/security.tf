# Default Security Group
resource "aws_security_group" "default" {
  name        = "${var.vpc_name}-default-sg"
  description = "Default security group for ${var.vpc_name}"
  vpc_id      = aws_vpc.main.id

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow internal traffic
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr_block]
  }

  tags = merge(
    {
      Name        = "${var.vpc_name}-default-sg"
      Environment = var.environment
    },
    var.tags
  )
}

# Network ACL for public subnets
resource "aws_network_acl" "public" {
  vpc_id     = aws_vpc.main.id
  subnet_ids = aws_subnet.public[*].id

  # Allow all inbound traffic
  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  # Allow all outbound traffic
  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = merge(
    {
      Name        = "${var.vpc_name}-public-nacl"
      Environment = var.environment
    },
    var.tags
  )
}

# Network ACL for private subnets
resource "aws_network_acl" "private" {
  vpc_id     = aws_vpc.main.id
  subnet_ids = aws_subnet.private[*].id

  # Allow all inbound VPC traffic
  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.vpc_cidr_block
    from_port  = 0
    to_port    = 0
  }

  # Allow returning inbound traffic from S3 VPC endpoint
  ingress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  # Allow all outbound traffic
  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = merge(
    {
      Name        = "${var.vpc_name}-private-nacl"
      Environment = var.environment
    },
    var.tags
  )
} 