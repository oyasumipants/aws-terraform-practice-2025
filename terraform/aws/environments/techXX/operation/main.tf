module "operation" {
  source = "../../../modules/operation"

  prefix    = "techXX" # 自分のチーム名に変更
  vpc_id    = data.terraform_remote_state.network.outputs.vpc_id
  subnet_id = data.terraform_remote_state.network.outputs.private_subnet_ids[0]

  instance_type    = "t3.micro"
  root_volume_size = 20

  # データベースシークレットのARNを設定
  db_secret_arn = data.terraform_remote_state.database.outputs.secret_arn

  tags = var.default_tags
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

data "terraform_remote_state" "database" {
  backend = "s3"
  config = {
    bucket = "ca25-techXX-terraform-state"                 # 自分のチーム名に変更
    key    = "terraform/techXX/database/terraform.tfstate" # 自分のチーム名に変更
    region = "ap-northeast-1"
    profile = "aws-handson"
  }
}
