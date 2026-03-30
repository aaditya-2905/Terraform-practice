output "sg_id" {
  value = aws_security_group.alb_sg.id
}

output "sg_for_alb" {
  description = "alb sg's"
  value       = aws_security_group.alb_sg.id
}