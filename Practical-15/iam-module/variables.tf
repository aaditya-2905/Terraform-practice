variable "iam_role1_name" {
  description = "Name of the IAM role for ECS task execution"
  type        = string
}

variable "iam_role2_name" {
  description = "Name of the IAM role for codedeploy"
  type        = string
}

output "codedeploy_role_arn" {
  value = aws_iam_role.codedeploy_role.arn
}