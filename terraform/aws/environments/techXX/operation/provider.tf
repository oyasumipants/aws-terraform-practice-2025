terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket  = "ca25-techXX-terraform-state"                  # 自分のチーム名に変更
    key     = "terraform/techXX/operation/terraform.tfstate" # 自分のチーム名に変更
    region  = "ap-northeast-1"
    encrypt = true
    profile = "aws-handson"
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = var.default_tags
  }
  profile = "aws-handson"
}
