variable "codedeploy_app_name" {
  description = "Name for codedeploy app"
  type = string
}

variable "alb_listener_arn" {
  description = "ARN of lb listener"
  type = string
}

variable "codedeploy_role_arn" {
  type = string
}

variable "alb_tg1_name" {
  description = "ARN of target group 1"
  type = string
}

variable "alb_tg2_name" {
  description = "ARN of target group 2"
  type = string
}

variable "cluster_name" {
    description = "cluster name for deployment group"
  type = string
}

variable "service_name" {
  description = "name of the ECS service for deployment group"
  type = string
}

variable "test_listener_arn" {
  type = string
}