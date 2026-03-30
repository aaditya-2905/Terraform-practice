output "alb_tg1_arn" {
  description = "ARN of target group 1"
  value       = aws_lb_target_group.alb_tg1.arn
}

output "alb_tg2_arn" {
  description = "ARN of target group 2"
  value       = aws_lb_target_group.alb_tg2.arn
}

output "alb_tg1_name" {
  description = "Name of target group 1"
  value       = aws_lb_target_group.alb_tg1.name
}

output "alb_tg2_name" {
  description = "Name of target group 2"
  value       = aws_lb_target_group.alb_tg2.name
}