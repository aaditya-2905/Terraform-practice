output "alb_id" {
  description = "id of the alb"
  value       = aws_lb.alb.id
}

output "lb_listener_arn" {
  description = "arn for load balancer"
  value = aws_lb.alb.arn
}

output "alb_arn" {
  value = aws_lb.alb.arn
}

output "prod_listener_arn" {
  value = aws_lb_listener.prod_listener.arn
}

output "test_listener_arn" {
  value = aws_lb_listener.test_listener.arn
}