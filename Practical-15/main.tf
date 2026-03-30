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
  sg_egress_rule  = var.sg_egress_rule
}

module "alb" {
  source         = "./alb-module"
  alb_name       = var.alb_name
  alb_subnet     = module.vpc.public_subnet_ids
  sg_for_alb     = [module.alb_sg.sg_for_alb]
  s3_bucket_name = var.s3_bucket_name

  alb_tg1_arn = module.alb_tg.alb_tg1_arn
  alb_tg2_arn = module.alb_tg.alb_tg2_arn
}

module "s3_bucket" {
  source         = "./s3-module"
  s3_bucket_name = var.s3_bucket_name
  s3_environment = var.s3_environment
}

module "iam_policies" {
  source         = "./iam-module"
  iam_role1_name = var.iam_role1_name
  iam_role2_name = var.iam_role2_name
}

module "alb_tg" {
  source       = "./targetgrp-module"
  vpc_id       = module.vpc.vpc_id
  alb_tg1_name = var.alb_tg1_name
  alb_tg2_name = var.alb_tg2_name
}

module "ecr_repo" {
  source   = "./ecr-module"
  ecr_repo = var.ecr_repo
}

module "ecs_cluster" {
  source = "./ecs-module"

  ecs_cluster_name        = var.ecs_cluster_name
  ecs_task_execution_role = module.iam_policies.ecs_execution_role_arn
  ecs_task_family         = var.ecs_task_family
  ecs_desired_count       = var.ecs_desired_count
  ecr_repo_url            = module.ecr_repo.ecr_repo_url
  alb_tg1_arn             = module.alb_tg.alb_tg1_arn
  alb_tg2_arn             = module.alb_tg.alb_tg2_arn

}

module "codedeploy" {
  source = "./codedeploy-module"

  codedeploy_app_name = var.codedeploy_app_name
  codedeploy_role_arn = module.iam_policies.codedeploy_role_arn
  alb_tg1_name        = module.alb_tg.alb_tg1_name
  alb_tg2_name        = module.alb_tg.alb_tg2_name
  alb_listener_arn    = module.alb.prod_listener_arn
  test_listener_arn   = module.alb.test_listener_arn

  cluster_name = module.ecs_cluster.ecs_cluster_name
  service_name = module.ecs_cluster.ecs_service_name

}
