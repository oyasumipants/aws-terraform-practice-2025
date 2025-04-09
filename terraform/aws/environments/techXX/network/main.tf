module "network" {
  source = "../../../modules/network"

  vpc_name              = var.vpc_name
  vpc_cidr_block        = var.vpc_cidr_block
  availability_zones    = var.availability_zones
  public_subnet_cidrs   = var.public_subnet_cidrs
  private_subnet_cidrs  = var.private_subnet_cidrs
  isolated_subnet_cidrs = var.isolated_subnet_cidrs
  environment           = var.environment
  tags                  = var.default_tags
}
