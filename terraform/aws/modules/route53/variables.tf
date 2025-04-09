variable "tags" {
  description = "Tags to be applied to all resources"
  type        = map(string)
  default     = {}
}

variable "domain_name" {
  description = "Domain name for the Route53 zone"
  type        = string
}

variable "zone_id" {
  description = "Zone ID for the Route53 zone"
  type        = string
}

variable "alias_records" {
  description = "Subdomain and ALB alias records"
  type = list(object({
    subdomain       = string
    target_dns_name = string
    target_zone_id  = string
  }))
  default = []
}

