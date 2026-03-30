output "iam_role1_name" {
  description = "Name of the IAM role for ECS task execution"
  value       = var.iam_role1_name
}

output "iam_role2_name" {
  description = "Name of the IAM role for codedeploy"
  value       = var.iam_role2_name
}

output "ecs_execution_role_arn" {
  value = aws_iam_role.ecs_task_execution_role.arn
}