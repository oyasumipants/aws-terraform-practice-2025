data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket  = "ca25-techXX-terraform-state"                # 自分のチーム名に変更
    key     = "terraform/techXX/network/terraform.tfstate" # 自分のチーム名に変更
    region  = "ap-northeast-1"
    profile = "aws-handson"
  }
}

data "terraform_remote_state" "ecr" {
  backend = "s3"
  config = {
    bucket  = "ca25-techXX-terraform-state"            # 自分のチーム名に変更
    key     = "terraform/techXX/ecr/terraform.tfstate" # 自分のチーム名に変更
    region  = "ap-northeast-1"
    profile = "aws-handson"
  }
}

# Add remote state for database
data "terraform_remote_state" "database" {
  backend = "s3"
  config = {
    bucket  = "ca25-techXX-terraform-state"                 # 自分のチーム名に変更
    key     = "terraform/techXX/database/terraform.tfstate" # 自分のチーム名に変更
    region  = "ap-northeast-1"
    profile = "aws-handson"
  }
}

data "aws_acm_certificate" "issued" {
  domain   = "*.${var.domain_name}"
  statuses = ["ISSUED"]
}
