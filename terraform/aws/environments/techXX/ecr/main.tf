module "ecr" {
  source = "../../../modules/ecr"

  repository_name = var.repository_name
  environment     = var.environment
  tags            = var.default_tags
}