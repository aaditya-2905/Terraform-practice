module "vpc" {
  source = "./vpc-module"

  vpc_cidr            = var.vpc_cidr
  vpc_tags            = var.vpc_tags
  public_subnet_cidrs = var.public_subnet_cidrs
}

module "alb_sg" {
  source = "./sg-module"
  vpc_id = module.vpc.vpc_id
  
  sg_ingress_rule = var.sg_ingress_rule
  sg_egress_rule = var.sg_egress_rule
}

