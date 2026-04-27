locals {
  common_tags = {
    created_by  = "terraform"
    module      = "alb-wrapper"
    environment = var.environment
  }
}

module "alb" {
  source = "aaditya-2905/alb/aws"

  name                       = var.name
  internal                   = var.internal
  vpc_id                     = var.vpc_id
  environment                = var.environment
  subnet_ids                 = var.subnet_ids
  sg_id                      = var.sg_id
  enable_deletion_protection = var.enable_deletion_protection

  target_groups = var.target_groups
  listeners     = var.listeners

  tags = merge(local.common_tags, var.tags)
}
