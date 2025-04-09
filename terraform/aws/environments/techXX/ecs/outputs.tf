output "alb_dns_name" {
  description = "ALB DNS name"
  value       = module.ecs.alb_dns_name
}

output "alb_zone_id" {
  description = "ALB hosted zone ID"
  value       = module.ecs.alb_zone_id
}

output "alb_arn" {
  description = "ALB ARN"
  value       = module.ecs.alb_arn
}

output "target_group_arn" {
  description = "Target group ARN"
  value       = module.ecs.target_group_arn
}

output "ecs_cluster_id" {
  description = "ECS cluster ID"
  value       = module.ecs.ecs_cluster_id
}

output "ecs_cluster_name" {
  description = "ECS cluster name"
  value       = module.ecs.ecs_cluster_name
}

output "ecs_service_id" {
  description = "ECS service ID"
  value       = module.ecs.ecs_service_id
}

output "ecs_service_name" {
  description = "ECS service name"
  value       = module.ecs.ecs_service_name
}

output "task_definition_arn" {
  description = "Task definition ARN"
  value       = module.ecs.task_definition_arn
}

output "task_execution_role_arn" {
  description = "Task execution role ARN"
  value       = module.ecs.task_execution_role_arn
}

output "task_role_arn" {
  description = "Task role ARN"
  value       = module.ecs.task_role_arn
}

output "cloudwatch_log_group_name" {
  description = "CloudWatch log group name"
  value       = module.ecs.cloudwatch_log_group_name
}

output "security_group_alb_id" {
  description = "ALB security group ID"
  value       = module.ecs.security_group_alb_id
}

output "security_group_ecs_tasks_id" {
  description = "ECS tasks security group ID"
  value       = module.ecs.security_group_ecs_tasks_id
}
