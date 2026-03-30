resource "aws_lb" "alb" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.sg_for_alb
  subnets            = var.alb_subnet

  enable_deletion_protection = true

  access_logs {
    bucket  = var.s3_bucket_name
    prefix  = "project1-alb"
    enabled = true
  }

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_listener" "prod_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = var.alb_tg1_arn   # BLUE initially
  }
}

resource "aws_lb_listener" "test_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 8080
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = var.alb_tg2_arn   # GREEN initially
  }
}
