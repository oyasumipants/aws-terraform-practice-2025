output "cluster_endpoint" {
  description = "The cluster endpoint"
  value       = aws_rds_cluster.bookshelf_db_cluster.endpoint
}

output "cluster_reader_endpoint" {
  description = "The cluster reader endpoint"
  value       = aws_rds_cluster.bookshelf_db_cluster.reader_endpoint
}

output "cluster_identifier" {
  description = "The cluster identifier"
  value       = aws_rds_cluster.bookshelf_db_cluster.cluster_identifier
}

output "database_name" {
  description = "Name of the database"
  value       = aws_rds_cluster.bookshelf_db_cluster.database_name
}

output "master_username" {
  description = "Master username for the database"
  value       = aws_rds_cluster.bookshelf_db_cluster.master_username
}

output "secret_arn" {
  description = "ARN of the Secrets Manager secret"
  value       = aws_secretsmanager_secret.bookshelf_db_password.arn
}

output "secret_name" {
  description = "Name of the Secrets Manager secret"
  value       = aws_secretsmanager_secret.bookshelf_db_password.name
}
