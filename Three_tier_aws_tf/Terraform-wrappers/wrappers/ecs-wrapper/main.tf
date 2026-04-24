locals {
  # Map-based configuration for ECS clusters
  clusters = var.clusters

  # Map-based configuration for ECS services
  ecs_services = var.ecs_services

  # Common tags for all resources
  common_tags = merge(
    var.common_tags,
    {
      created_by = "terraform"
      module     = "ecs-wrapper"
    }
  )
}

# ECS Clusters
resource "aws_ecs_cluster" "cluster" {
  for_each = local.clusters

  name = each.value.name

  setting {
    name  = each.value.setting
    value = each.value.container_insights
  }

  tags = merge(
    local.common_tags,
    each.value.tags,
    {
      Name = each.value.name
    }
  )
}

resource "aws_ecs_cluster_capacity_providers" "cluster_providers" {
  for_each = local.clusters

  cluster_name = aws_ecs_cluster.cluster[each.key].name

  capacity_providers = each.value.capacity_providers

  default_capacity_provider_strategy {
    weight            = 100
    capacity_provider = each.value.default_capacity_provider
  }
}

# ECS Services & Tasks
module "service" {
  for_each = local.ecs_services

  source = "aaditya-2905/ecs/aws"

  cluster_name                   = each.value.cluster_name
  service_name                   = each.value.service_name
  task_family                    = each.value.task_family
  container_name                 = each.value.container_name
  image                          = each.value.image
  cpu                            = each.value.cpu
  memory                         = each.value.memory
  port_mappings                  = each.value.port_mappings
  execution_role_arn             = each.value.execution_role_arn
  task_role_arn                  = each.value.task_role_arn
  network_mode                   = each.value.network_mode
  subnets                        = each.value.subnets
  security_groups                = each.value.security_groups
  assign_public_ip               = each.value.assign_public_ip
  desired_count                  = each.value.desired_count
  launch_type                    = each.value.launch_type
  deployment_min_healthy_percent = each.value.deployment_min_healthy_percent
  deployment_max_percent         = each.value.deployment_max_percent
  target_group_arn               = each.value.target_group_arn
  container_port                 = each.value.container_port
  log_group_name                 = each.value.log_group_name
  log_region                     = each.value.log_region
  environment_variables          = each.value.environment_variables
  secrets                        = each.value.secrets

  tags = merge(
    local.common_tags,
    each.value.tags,
    {
      Name = each.value.service_name
    }
  )
}

output "cluster_arns" {
  description = "ARNs of created ECS clusters"
  value       = { for k, v in aws_ecs_cluster.cluster : k => v.arn }
}

output "service_arns" {
  description = "ARNs of created ECS services"
  value       = { for k, v in module.service : k => v.service_arn }
}
