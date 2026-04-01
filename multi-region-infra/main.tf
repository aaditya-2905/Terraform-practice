module "vpc_mumbai" {
  source                     = "aaditya-2905/vpc/aws"
  vpc_cidr_block             = var.vpc_cidr_block
  environment                = var.environment
  availability_zones         = var.mumbai_az
  public_subnet_cidr_blocks  = var.public_subnet_cidr_blocks
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
  project                    = "multi-region-infra-mumbai"
  single_nat_gateway         = false
  providers = {
    aws = aws.mumbai
  }
}

module "vpc_us" {
  source                     = "aaditya-2905/vpc/aws"
  vpc_cidr_block             = var.vpc_cidr_block
  environment                = var.environment
  availability_zones         = var.us_az
  public_subnet_cidr_blocks  = var.public_subnet_cidr_blocks
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
  project                    = "multi-region-infra-us"
  single_nat_gateway         = false
  providers = {
    aws = aws.us
  }
}

module "sg_mumbai" {
  source      = "github.com/aaditya-2905/terraform-aws-sg"
  vpc_id      = module.vpc_mumbai.vpc_id
  environment = var.environment
  ingress_rules = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  providers = {
    aws = aws.mumbai
  }
}

module "sg_us" {
  source      = "github.com/aaditya-2905/terraform-aws-sg"
  vpc_id      = module.vpc_us.vpc_id
  environment = var.environment
  ingress_rules = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  providers = {
    aws = aws.us
  }
}

module "ec2_mumbai" {
  source         = "aaditya-2905/ec2/aws"
  environment    = var.environment
  ami            = var.ami_id_mumbai
  subnet_id      = module.vpc_mumbai.public_subnet_ids[0]
  sg_id          = module.sg_mumbai.sg_id
  instance_names = ["ec2-mumbai"]
  providers = {
    aws = aws.mumbai
  }
}

module "ec2_us" {
  source         = "aaditya-2905/ec2/aws"
  environment    = var.environment
  ami            = var.ami_id_us
  subnet_id      = module.vpc_us.public_subnet_ids[0]
  sg_id          = module.sg_us.sg_id
  instance_names = ["ec2-us"]
  providers = {
    aws = aws.us
  }
}

module "alb_mumbai" {
  source      = "aaditya-2905/alb/aws"
  name        = "alb-mumbai"
  version     = "v1.4.0"
  environment = var.environment
  vpc_id      = module.vpc_mumbai.vpc_id
  subnet_ids  = module.vpc_mumbai.public_subnet_ids
  sg_id       = module.sg_mumbai.sg_id

  target_groups = {
    tg-mumbai = {
      port        = 80
      protocol    = "HTTP"
      target_type = "instance"
    }
  }

  listeners = {
    listener-80 = {
      port             = 80
      protocol         = "HTTP"
      target_group_key = "tg-mumbai"
    }
  }
  providers = {
    aws = aws.mumbai
  }
}

resource "aws_lb_target_group_attachment" "mumbai" {
  for_each = {
    for idx, name in ["ec2-mumbai"] :
    name => module.ec2_mumbai.instance_ids[idx]
  }

  target_group_arn = module.alb_mumbai.target_group_arns["tg-mumbai"]
  target_id        = each.value
  port             = 80

  provider = aws.mumbai
}

module "alb_us" {
  source      = "aaditya-2905/alb/aws"
  name        = "alb-us"
  version     = "v1.4.0"
  environment = var.environment
  vpc_id      = module.vpc_us.vpc_id
  subnet_ids  = module.vpc_us.public_subnet_ids
  sg_id       = module.sg_us.sg_id

  target_groups = {
    tg-us = {
      port        = 80
      protocol    = "HTTP"
      target_type = "instance"
    }
  }

  listeners = {
    listener-80 = {
      port             = 80
      protocol         = "HTTP"
      target_group_key = "tg-us"
    }
  }

  providers = {
    aws = aws.us
  }
}

resource "aws_lb_target_group_attachment" "us" {
  for_each = {
    for idx, name in ["ec2-us"] :
    name => module.ec2_us.instance_ids[idx]
  }

  target_group_arn = module.alb_us.target_group_arns["tg-us"]
  target_id        = each.value
  port             = 80

  provider = aws.us
}
