output "cluster_endpoint" {
  description = "The cluster endpoint"
  value       = module.database.cluster_endpoint
}

output "cluster_reader_endpoint" {
  description = "The cluster reader endpoint"
  value       = module.database.cluster_reader_endpoint
}

output "database_name" {
  description = "Name of the database"
  value       = module.database.database_name
}

output "master_username" {
  description = "Master username for the database"
  value       = module.database.master_username
}

output "secret_arn" {
  description = "ARN of the Secrets Manager secret"
  value       = module.database.secret_arn
}

output "secret_name" {
  description = "Name of the Secrets Manager secret"
  value       = module.database.secret_name
}
