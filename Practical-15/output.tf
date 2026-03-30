output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "alb_tg1_arn" {
  value = module.alb_tg.alb_tg1_arn
}

output "alb_tg2_arn" {
  value = module.alb_tg.alb_tg2_arn
}

output "alb_tg1_name" {
  value = module.alb_tg.alb_tg1_name
}

output "alb_tg2_name" {
  value = module.alb_tg.alb_tg2_name
}

output "prod_listener_arn" {
  value = module.alb.prod_listener_arn
}

output "test_listener_arn" {
  value = module.alb.test_listener_arn
}

output "ecs_service_name" {
  value = module.ecs_cluster.ecs_service_name
}

output "ecs_cluster_name" {
  value = module.ecs_cluster.ecs_cluster_name
}

output "task_definition_arn" {
  value = module.ecs_cluster.task_definition_arn
}

output "ecr_repo_url" {
  value = module.ecr_repo.ecr_repo_url
}

output "codedeploy_app_name" {
  value = module.codedeploy.codedeploy_app_name
}

output "deployment_group_name" {
  value = module.codedeploy.deployment_group_name
}