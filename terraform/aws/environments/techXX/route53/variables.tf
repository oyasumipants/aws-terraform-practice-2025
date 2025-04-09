variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-1"
}

variable "default_tags" {
  description = "Default tags for all resources"
  type        = map(string)
  default = {
    Project   = "techXX-handson" # チーム名を変更
    ManagedBy = "terraform"
  }
}

variable "domain_name" {
  description = "Domain name"
  type        = string
  # default     = "your-domain-name"
}

variable "sub_domain_prefix" {
  description = "Subdomain prefix"
  type        = string
  # default     = "your-name"
}

