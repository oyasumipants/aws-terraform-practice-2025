# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    {
      Name        = var.vpc_name
      Environment = var.environment
    },
    var.tags
  )
}

# Public Subnets
resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    {
      Name        = "${var.vpc_name}-public-${var.availability_zones[count.index]}"
      Environment = var.environment
      Type        = "Public"
    },
    var.tags
  )
}

# Private Subnets
resource "aws_subnet" "private" {
  count                   = length(var.private_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false

  tags = merge(
    {
      Name        = "${var.vpc_name}-private-${var.availability_zones[count.index]}"
      Environment = var.environment
      Type        = "Private"
    },
    var.tags
  )
}

# Isolated Subnets (no internet access)
resource "aws_subnet" "isolated" {
  count                   = length(var.isolated_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.isolated_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false

  tags = merge(
    {
      Name        = "${var.vpc_name}-isolated-${var.availability_zones[count.index]}"
      Environment = var.environment
      Type        = "Isolated"
    },
    var.tags
  )
}
