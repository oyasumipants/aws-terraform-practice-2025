output "repository_url" {
  description = "The URL of the repository (in the form `aws_account_id.dkr.ecr.region.amazonaws.com/repositoryName`)"
  value       = module.ecr.repository_url
}

output "repository_name" {
  description = "The name of the repository"
  value       = module.ecr.repository_name
}
