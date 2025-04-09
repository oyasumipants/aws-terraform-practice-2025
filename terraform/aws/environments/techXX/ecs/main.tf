module "ecs" {
  source = "../../../modules/ecs"

  # Depends on network and ecr modules.
  vpc_id                  = data.terraform_remote_state.network.outputs.vpc_id
  public_subnet_ids       = data.terraform_remote_state.network.outputs.public_subnet_ids
  private_subnet_ids      = data.terraform_remote_state.network.outputs.private_subnet_ids
  ecr_repository_url      = data.terraform_remote_state.ecr.outputs.repository_url
  private_route_table_ids = data.terraform_remote_state.network.outputs.private_route_table_ids

  # Database connection information
  database_host       = data.terraform_remote_state.database.outputs.cluster_endpoint
  database_secret_arn = data.terraform_remote_state.database.outputs.secret_arn

  environment     = var.environment
  app_name        = "${local.app_prefix}-${var.app_name}"
  image_tag       = var.image_tag
  container_port  = var.container_port
  desired_count   = var.desired_count
  cpu             = var.cpu
  memory          = var.memory
  task_cpu        = var.task_cpu
  task_memory     = var.task_memory
  certificate_arn = data.aws_acm_certificate.issued.arn
}
