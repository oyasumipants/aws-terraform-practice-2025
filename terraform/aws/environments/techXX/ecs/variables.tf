variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-1"
}

variable "environment" {
  description = "Environment name (dev, stg, prod, etc.)"
  type        = string
  default     = "dev"
}

variable "app_name" {
  description = "Application name"
  type        = string
  # default     = "your-name" # 自分の名前に変更
}

variable "image_tag" {
  description = "Tag of the container image"
  type        = string
  # default     = "v1" # 自分のバージョンに変更
}

variable "container_port" {
  description = "Container port"
  type        = number
  default     = 8080
}

variable "desired_count" {
  description = "Number of tasks for ECS service"
  type        = number
  default     = 2
}

variable "cpu" {
  description = "CPU units for container"
  type        = number
  default     = 256
}

variable "memory" {
  description = "Memory (MiB) for container"
  type        = number
  default     = 512
}

variable "task_cpu" {
  description = "CPU units for task"
  type        = number
  default     = 256
}

variable "task_memory" {
  description = "Memory (MiB) for task"
  type        = number
  default     = 512
}

variable "health_check_path" {
  description = "Health check path"
  type        = string
  default     = "/live"
}

variable "log_retention_days" {
  description = "CloudWatch logs retention in days"
  type        = number
  default     = 30
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
  # default     = "your-domain-name" # 自分のチームのドメイン名に変更
}
