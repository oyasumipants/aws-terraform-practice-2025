# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    {
      Name        = "${var.vpc_name}-public-rt"
      Environment = var.environment
      Type        = "Public"
    },
    var.tags
  )
}

# Private Route Tables (one per AZ)
resource "aws_route_table" "private" {
  count  = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.main.id

  tags = merge(
    {
      Name        = "${var.vpc_name}-private-rt-${var.availability_zones[count.index]}"
      Environment = var.environment
      Type        = "Private"
    },
    var.tags
  )
}

# Isolated Route Tables (one per AZ) - No internet access
resource "aws_route_table" "isolated" {
  count  = length(var.isolated_subnet_cidrs)
  vpc_id = aws_vpc.main.id

  tags = merge(
    {
      Name        = "${var.vpc_name}-isolated-rt-${var.availability_zones[count.index]}"
      Environment = var.environment
      Type        = "Isolated"
    },
    var.tags
  )
}

# Public Route
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

# Private Routes
resource "aws_route" "private_nat_gateway" {
  count                  = length(var.private_subnet_cidrs)
  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main[count.index].id
}

# Public Subnet Route Table Associations
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Private Subnet Route Table Associations
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

# Isolated Subnet Route Table Associations
resource "aws_route_table_association" "isolated" {
  count          = length(var.isolated_subnet_cidrs)
  subnet_id      = aws_subnet.isolated[count.index].id
  route_table_id = aws_route_table.isolated[count.index].id
}
