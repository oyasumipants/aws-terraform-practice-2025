variable "repository_name" {
  description = "Repository name"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, stg, prod, etc.)"
  type        = string
}

variable "tags" {
  description = "Tags to be applied to resources"
  type        = map(string)
  default     = {}
}
