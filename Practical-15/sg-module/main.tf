resource "aws_security_group" "alb_sg" {
  vpc_id = var.vpc_id
}
