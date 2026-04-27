variable "aws_region" {
  description = "AWS region where resources will be deployed"
  type        = string
  default     = "us-east-1"
}

variable "common_tags" {
  description = "Common tags to apply to all ECS resources"
  type        = map(string)
  default     = {}
}

variable "clusters" {
  description = "Map of ECS cluster configurations"
  type = map(object({
    name                      = string
    capacity_providers        = optional(list(string), ["FARGATE"])
    default_capacity_provider = optional(string, "FARGATE")
    container_insights        = optional(string, "disabled")
    enable_execute_command    = optional(bool, false)
    setting                   = optional(string, "containerInsights")
    tags                      = optional(map(string), {})
  }))
  default = {}
}

variable "ecs_services" {
  description = "Map of ECS service and task configurations"
  type = map(object({
    cluster_name                   = string
    service_name                   = string
    task_family                    = string
    container_name                 = string
    image                          = string
    cpu                            = optional(string, "256")
    memory                         = optional(string, "512")
    port_mappings                  = optional(any)
    execution_role_arn             = optional(string)
    task_role_arn                  = optional(string)
    network_mode                   = optional(string, "awsvpc")
    subnets                        = optional(list(string), [])
    security_groups                = optional(list(string), [])
    assign_public_ip               = optional(bool, false)
    desired_count                  = optional(number, 1)
    launch_type                    = optional(string, "FARGATE")
    deployment_min_healthy_percent = optional(number, 100)
    deployment_max_percent         = optional(number, 200)
    target_group_arn               = optional(string)
    container_port                 = optional(number)
    log_group_name                 = optional(string)
    log_region                     = optional(string)
    environment_variables          = optional(any)
    secrets                        = optional(any)
    tags                           = optional(map(string), {})
  }))
  default = {}
}
