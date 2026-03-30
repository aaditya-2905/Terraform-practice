variable "ecs_cluster_name" {
  description = "name for ecs cluster"
  type = string
}

variable "ecs_task_execution_role" {
  description = "role for task"
  type = string
}

variable "ecs_task_family" {
  description = "value for task family"
  type = string
}

variable "ecs_desired_count" {
  description = "desired count for ecs service"
  type = number
}

variable "ecr_repo_url" {
  description = "Url of ecr repo"
  type = string
}

variable "alb_tg1_arn" {
  description = "ARN of target group 1"
  type = string
}

variable "alb_tg2_arn" {
  description = "ARN of target group 2"
  type = string
}