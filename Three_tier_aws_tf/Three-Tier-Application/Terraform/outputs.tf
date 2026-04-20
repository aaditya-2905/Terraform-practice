output "vpc_id" {
  value = module.vpc.vpc_id
}

output "ecs_task_role_arn" {
  value = module.iam.ecs_task_role_arn
}

output "ecs_task_execution_role_arn" {
  value = module.iam.ecs_task_execution_role_arn
}

output "ecr_repository_url" {
  value = module.ecr.ecr_repository_url
}

output "primary_alb_dns" {
  value = module.alb.alb_dns_name
}

output "secondary_alb_dns" {
  value = module.alb_secondary.alb_dns_name
}

output "cloudfront_domain_name" {
  value = module.cloudfront.cloudfront_domain_name
}
