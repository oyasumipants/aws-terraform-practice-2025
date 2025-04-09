variable "environment" {
  description = "Environment name (dev, stg, prod, etc.)"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "private_route_table_ids" {
  description = "List of IDs of private route tables. This is used for S3 VPC endpoint."
  type        = list(string)
}

variable "app_name" {
  description = "Application name"
  type        = string
}

variable "ecr_repository_url" {
  description = "ECR repository URL"
  type        = string
}

variable "image_tag" {
  description = "Tag of the container image"
  type        = string
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

variable "tags" {
  description = "Tags to be applied to resources"
  type        = map(string)
  default     = {}
}

variable "database_host" {
  description = "Host address of the database"
  type        = string
  default     = ""
}

variable "database_secret_arn" {
  description = "ARN of the database secret in Secrets Manager"
  type        = string
  default     = ""
}

variable "certificate_arn" {
  description = "ARN of the SSL certificate"
  type        = string
}
