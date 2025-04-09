variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-1"
}

variable "default_tags" {
  description = "Default tags for all resources"
  type        = map(string)
  default = {
    Project   = "techXX-handson" # 自分のチーム名に変更
    ManagedBy = "terraform"
  }
}
