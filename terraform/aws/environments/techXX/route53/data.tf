data "terraform_remote_state" "ecs" {
  backend = "s3"
  config = {
    bucket  = "ca25-techXX-terraform-state"                      # 自分のチーム名に変更
    key     = "terraform/techXX/ecs/user-name/terraform.tfstate" # 自分のチーム名,名前に変更
    region  = "ap-northeast-1"
    profile = "aws-handson"
  }
}

data "aws_route53_zone" "handson" {
  name = var.domain_name
}
