variable "prefix" {
  description = "Prefix for all resources"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, stg, prod, etc.)"
  type        = string
}

variable "private_subnet_cidrs" {
  description = "List of private subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.16.0/20", "10.0.32.0/20"]
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "isolated_subnet_ids" {
  description = "List of isolated subnet IDs"
  type        = list(string)
}

variable "engine_version" {
  description = "Aurora MySQL engine version"
  type        = string
  default     = "8.0.mysql_aurora.3.05.1"
}

variable "master_username" {
  description = "Username for the master DB user"
  type        = string
  default     = "admin"
}

variable "instance_class" {
  description = "Instance class for Aurora instances"
  type        = string
  default     = "db.t4g.medium"
}

variable "instance_count" {
  description = "Number of Aurora instances"
  type        = number
  default     = 1
}

variable "backup_retention_period" {
  description = "Days to retain backups"
  type        = number
  default     = 1
}

variable "preferred_backup_window" {
  description = "The daily time range during which automated backups are created"
  type        = string
  default     = "03:00-04:00"
}

variable "skip_final_snapshot" {
  description = "Whether to skip final snapshot when destroying the cluster"
  type        = bool
  default     = false
}

variable "security_group_id" {
  description = "ID of the security group for the Aurora cluster"
  type        = string
}

variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = {}
}

variable "enable_db_scheduler" {
  description = "Whether to enable the EventBridge Scheduler for starting and stopping the Aurora DB cluster"
  type        = bool
  default     = false
}

variable "db_start_schedule" {
  description = "CRON expression for when to start the Aurora DB cluster (UTC timezone)"
  type        = string
  default     = "cron(0 1 ? * MON-FRI *)"
}

variable "db_stop_schedule" {
  description = "CRON expression for when to stop the Aurora DB cluster (UTC timezone)"
  type        = string
  default     = "cron(0 10 ? * MON-FRI *)"
}
