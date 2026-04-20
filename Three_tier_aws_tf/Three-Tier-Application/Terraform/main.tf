module "vpc" {
  source = "aaditya-2905/vpc/aws"

  vpc_cidr_block             = var.vpc_cidr
  public_subnet_cidr_blocks  = var.public_subnets
  private_subnet_cidr_blocks = var.private_subnets
  availability_zones         = var.azs
  enable_nat_gateway         = true
  environment                = "dev"

  additional_tags = {
    Name = "three-tier-vpc-${var.aws_region}"
  }
}

module "vpc_secondary" {
  source = "aaditya-2905/vpc/aws"

  providers = {
    aws = aws.secondary
  }

  vpc_cidr_block             = var.secondary_vpc_cidr
  public_subnet_cidr_blocks  = var.secondary_public_subnets
  private_subnet_cidr_blocks = var.secondary_private_subnets
  availability_zones         = var.secondary_azs
  enable_nat_gateway         = true
  environment                = "dev"

  additional_tags = {
    Name = "three-tier-vpc-sec-${var.secondary_region}"
  }
}

module "s3" {
  source = "./s3"
  region = var.aws_region
}

module "sg" {
  source = "aaditya-2905/sg/aws"

  vpc_id        = module.vpc.vpc_id
  ingress_rules = var.sg_ingress_rules
  egress_rules  = var.sg_egress_rules
  environment   = "dev"
}

module "sg_secondary" {
  source = "aaditya-2905/sg/aws"

  providers = {
    aws = aws.secondary
  }

  vpc_id        = module.vpc_secondary.vpc_id
  ingress_rules = var.sg_ingress_rules
  egress_rules  = var.sg_egress_rules
  environment   = "dev"
}

module "alb" {
  source  = "aaditya-2905/alb/aws"
  version = "1.5.0"

  name        = "three-tier-alb-${var.aws_region}"
  vpc_id      = module.vpc.vpc_id
  subnet_ids  = module.vpc.public_subnet_ids
  sg_id       = module.sg.sg_id
  environment = "dev"
  internal    = false

  target_groups = {
    app = {
      name_prefix      = "app"
      backend_protocol = "HTTP"
      backend_port     = 3000
      target_type      = "ip"

      health_check = {
        path                = "/api/health"
        interval            = 30
        timeout             = 5
        healthy_threshold   = 2
        unhealthy_threshold = 2
        matcher             = "200"
        port                = "3000"
      }
    }
  }

  listeners = {
    http = {
      target_group_key   = "app"
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  }

  tags = {
    Environment = "dev"
    Project     = "three-tier-${var.aws_region}"
  }
}

module "alb_secondary" {
  source  = "aaditya-2905/alb/aws"
  version = "1.5.0"

  providers = {
    aws = aws.secondary
  }

  name        = "three-tier-alb-sec-${var.secondary_region}"
  vpc_id      = module.vpc_secondary.vpc_id
  subnet_ids  = module.vpc_secondary.public_subnet_ids
  sg_id       = module.sg_secondary.sg_id
  environment = "dev"
  internal    = false

  target_groups = {
    app = {
      name_prefix      = "app"
      backend_protocol = "HTTP"
      backend_port     = 3000
      target_type      = "ip"

      health_check = {
        path                = "/api/health"
        interval            = 30
        timeout             = 5
        healthy_threshold   = 2
        unhealthy_threshold = 2
        matcher             = "200"
        port                = "3000"
      }
    }
  }

  listeners = {
    http = {
      target_group_key   = "app"
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  }

  tags = {
    Environment = "dev"
    Project     = "three-tier-${var.secondary_region}"
  }
}

module "iam" {
  source = "./iam"

  ecs_task_role_name           = "ecs-task-role-${var.aws_region}"
  ecs_task_execution_role_name = "ecs-task-execution-role-${var.aws_region}"
}

module "ecr" {
  source = "./ecr"

  aws_region                  = var.aws_region
  ecs_task_execution_role_arn = module.iam.ecs_task_execution_role_arn
}

module "rds_global" {
  source = "./rds-global"

  providers = {
    aws           = aws
    aws.secondary = aws.secondary
  }

  primary_vpc_id     = module.vpc.vpc_id
  primary_subnets    = module.vpc.private_subnet_ids
  primary_vpc_cidr   = var.vpc_cidr
  secondary_vpc_id   = module.vpc_secondary.vpc_id
  secondary_subnets  = module.vpc_secondary.private_subnet_ids
  secondary_vpc_cidr = var.secondary_vpc_cidr
  primary_sg_id      = module.sg.sg_id
  secondary_sg_id    = module.sg_secondary.sg_id
}

module "ecs_primary" {
  source = "./ecs"

  aws_region           = var.aws_region
  ecr_image_url        = module.ecr.ecr_repository_url
  alb_target_group_arn = module.alb.target_group_arns["app"]
  pvt_subnet_ids       = module.vpc.private_subnet_ids
  sg_id                = [module.sg.sg_id]
  db_cluster_endpoint  = module.rds_global.primary_cluster_endpoint
  db_secret_arn        = module.rds_global.master_user_secret_arn
}

module "ecs_secondary" {
  source = "./ecs"

  providers = {
    aws = aws.secondary
  }

  aws_region           = var.secondary_region
  ecr_image_url        = module.ecr.ecr_repository_url
  alb_target_group_arn = module.alb_secondary.target_group_arns["app"]
  pvt_subnet_ids       = module.vpc_secondary.private_subnet_ids
  sg_id                = [module.sg_secondary.sg_id]
  db_cluster_endpoint  = module.rds_global.reader_endpoint
  db_secret_arn        = module.rds_global.master_user_secret_arn
}

module "cloudfront" {
  source                      = "./cloudfront"
  bucket_regional_domain_name = module.s3.s3_bucket_domain_name
  primary_alb_dns_name        = module.alb.alb_dns_name
  secondary_alb_dns_name      = module.alb_secondary.alb_dns_name
  cf_origin_secret            = var.cf_origin_secret
  region                      = var.aws_region
}

resource "aws_wafv2_web_acl" "alb_waf_primary" {
  name  = "alb-protection-waf-primary"
  scope = "REGIONAL"

  default_action {
    block {}
  }

  rule {
    name     = "allow-cloudfront-header"
    priority = 1

    action {
      allow {}
    }

    statement {
      byte_match_statement {
        field_to_match {
          single_header {
            name = "x-origin-secret"
          }
        }
        search_string         = var.cf_origin_secret
        positional_constraint = "EXACTLY"
        text_transformation {
          priority = 0
          type     = "NONE"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "allow-cloudfront-header-primary"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "alb-waf-primary"
    sampled_requests_enabled   = true
  }
}

resource "aws_wafv2_web_acl_association" "alb_primary_assoc" {
  resource_arn = module.alb.lb_arn
  web_acl_arn  = aws_wafv2_web_acl.alb_waf_primary.arn
  depends_on   = [module.alb]
}

resource "aws_wafv2_web_acl" "alb_waf_secondary" {
  provider = aws.secondary
  name     = "alb-protection-waf-secondary"
  scope    = "REGIONAL"

  default_action {
    block {}
  }

  rule {
    name     = "allow-cloudfront-header"
    priority = 1

    action {
      allow {}
    }

    statement {
      byte_match_statement {
        field_to_match {
          single_header {
            name = "x-origin-secret"
          }
        }
        search_string         = var.cf_origin_secret
        positional_constraint = "EXACTLY"
        text_transformation {
          priority = 0
          type     = "NONE"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "allow-cloudfront-header-secondary"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "alb-waf-secondary"
    sampled_requests_enabled   = true
  }
}

resource "aws_wafv2_web_acl_association" "alb_secondary_assoc" {
  provider     = aws.secondary
  resource_arn = module.alb_secondary.lb_arn
  web_acl_arn  = aws_wafv2_web_acl.alb_waf_secondary.arn
  depends_on   = [module.alb_secondary]
}

resource "aws_route53_zone" "main" {
  name = "three-tier-app.rohanmatre.in"
}

resource "aws_route53_record" "primary" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "app.three-tier-app.rohanmatre.in"
  type    = "A"

  set_identifier = "primary"

  failover_routing_policy {
    type = "PRIMARY"
  }

  alias {
    name                   = module.cloudfront.cloudfront_domain_name
    zone_id                = module.cloudfront.cloudfront_hosted_zone_id
    evaluate_target_health = true
  }

  health_check_id = aws_route53_health_check.primary.id
}

resource "aws_route53_record" "secondary" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "app.three-tier-app.rohanmatre.in"
  type    = "A"

  set_identifier = "secondary"

  failover_routing_policy {
    type = "SECONDARY"
  }

  alias {
    name                   = module.cloudfront.cloudfront_domain_name
    zone_id                = module.cloudfront.cloudfront_hosted_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_health_check" "primary" {
  fqdn              = module.alb.alb_dns_name
  port              = 80
  type              = "HTTP"
  resource_path     = "/health"
  failure_threshold = 3
  request_interval  = 30
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${module.s3.s3_arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [module.cloudfront.cloudfront_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = module.s3.s3_bucket_id
  policy = data.aws_iam_policy_document.s3_policy.json
}
