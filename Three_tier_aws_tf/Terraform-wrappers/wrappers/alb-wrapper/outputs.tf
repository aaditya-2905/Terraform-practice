output "alb_arn" {
  description = "The ARN of the created load balancer"
  value       = module.alb.lb_arn
}

output "alb_dns_name" {
  description = "The DNS name of the VPC"
  value       = module.alb.alb_dns_name
}

output "target_group_arns" {
  description = "ARNs of the created target groups"
  value       = module.alb.target_group_arns
}
