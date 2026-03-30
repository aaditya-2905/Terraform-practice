output "ecs_cluster_name" {
  value = aws_ecs_cluster.ecs_cluster.name
}

output "ecs_service_name" {
  value = aws_ecs_service.ecs_service.name
}

output "task_definition_arn" {
  value = aws_ecs_task_definition.ecs_task.arn
}

output "ecs_cluster_arn" {
  value = aws_ecs_cluster.ecs_cluster.arn
}