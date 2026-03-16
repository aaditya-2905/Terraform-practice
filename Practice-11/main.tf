module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  for_each = length(var.Vpc) > 0 ? { for idx, vpc in var.Vpc : idx => vpc } : {}
  name     = each.value.Vpc_name
  cidr     = each.value.Vpc_cidr

  public_subnets = [each.value.subnet1.subnet_cidr, each.value.subnet2.subnet_cidr]
  azs            = [each.value.subnet1.availability_zone, each.value.subnet2.availability_zone]
  tags = {
    Terraform = "true"
  }
}

resource "aws_security_group" "Test_sg" {
  name        = "Test_sg"
  description = "Security group for Test_asg"
  vpc_id      = module.vpc["0"].vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_launch_template" "Test_ec2_template" {
  name_prefix            = "Test_ec2_template"
  image_id               = "ami-0b6c6ebed2801a5cb"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.Test_sg.id]
  user_data = base64encode(<<EOF
#!/bin/bash
sudo apt update -y
sudo apt install nginx -y
systemctl start nginx
systemctl enable nginx
echo "Hello from Auto Scaling Instance" > /usr/share/nginx/html/index.html
EOF
  )
}

resource "aws_lb_target_group" "Test_target_group" {
  name     = "Test-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc["0"].vpc_id

  health_check {
    path = "/"
  }
}

resource "aws_alb" "Test_alb" {
  name               = "Test-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.Test_sg.id]
  subnets            = module.vpc["0"].public_subnets
}

resource "aws_alb_listener" "Test_listener" {
  load_balancer_arn = aws_alb.Test_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.Test_target_group.arn
  }
}

resource "aws_autoscaling_group" "Test_asg" {
  name             = "Test_asg"
  max_size         = 2
  min_size         = 1
  desired_capacity = 1
  launch_template {
    id      = aws_launch_template.Test_ec2_template.id
    version = "$Latest"
  }
  vpc_zone_identifier = module.vpc["0"].public_subnets
  target_group_arns   = [aws_lb_target_group.Test_target_group.arn]
  health_check_type   = "ELB"

}

resource "aws_autoscaling_policy" "Test_policy" {
  name                   = "Test_policy"
  autoscaling_group_name = aws_autoscaling_group.Test_asg.name
  policy_type            = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0
  }
}

