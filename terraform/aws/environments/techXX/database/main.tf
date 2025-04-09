module "database" {
  source = "../../../modules/database"

  prefix              = "techXX" # 自分のチーム名に変更
  environment         = "dev"
  vpc_id              = data.terraform_remote_state.network.outputs.vpc_id
  isolated_subnet_ids = data.terraform_remote_state.network.outputs.isolated_subnet_ids
  security_group_id   = data.terraform_remote_state.network.outputs.default_security_group_id

  instance_class = "db.t3.medium"
  engine_version = "8.0.mysql_aurora.3.08.1"
  instance_count = 1

  backup_retention_period = 1
  preferred_backup_window = "03:00-04:00"
  skip_final_snapshot     = true
  enable_db_scheduler     = true
  tags                    = var.default_tags
}

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "ca25-techXX-terraform-state"                # 自分のチーム名に変更
    key    = "terraform/techXX/network/terraform.tfstate" # 自分のチーム名に変更
    region = "ap-northeast-1"
    profile = "aws-handson"
  }
}
