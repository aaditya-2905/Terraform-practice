# ═══════════════════════════════════════════════════════════════
# Root Terraform configuration — Three-Tier Application
# All infrastructure is provisioned through wrapper modules from
# Terraform-wrappers/wrappers/.  No local sub-modules are used
# except rds-global (no wrapper available).
# ═══════════════════════════════════════════════════════════════

# ─── VPC (map-based wrapper) ──────────────────────────────────
module "vpc" {
  source = "../../Terraform-wrappers/wrappers/vpc-wrapper"
  vpcs   = var.vpcs
}

# ─── Data sources: look up subnets created by VPC wrapper ─────
# The VPC wrapper only exposes vpc_ids and vpc_cidr_blocks.
# We use data sources to discover the subnet IDs by CIDR block.

data "aws_subnets" "primary_public" {
  filter {
    name   = "vpc-id"
    values = [module.vpc.vpc_ids["primary"]]
  }
  filter {
    name   = "cidr-block"
    values = var.vpcs["primary"].public_subnet_cidr_blocks
  }
}

data "aws_subnets" "primary_private" {
  filter {
    name   = "vpc-id"
    values = [module.vpc.vpc_ids["primary"]]
  }
  filter {
    name   = "cidr-block"
    values = var.vpcs["primary"].private_subnet_cidr_blocks
  }
}

data "aws_subnets" "secondary_public" {
  provider = aws.secondary

  filter {
    name   = "vpc-id"
    values = [module.vpc.vpc_ids["secondary"]]
  }
  filter {
    name   = "cidr-block"
    values = var.vpcs["secondary"].public_subnet_cidr_blocks
  }
}

data "aws_subnets" "secondary_private" {
  provider = aws.secondary

  filter {
    name   = "vpc-id"
    values = [module.vpc.vpc_ids["secondary"]]
  }
  filter {
    name   = "cidr-block"
    values = var.vpcs["secondary"].private_subnet_cidr_blocks
  }
}

# ─── Security Groups (map-based wrapper) ──────────────────────
module "sg" {
  source = "../../Terraform-wrappers/wrappers/sg-wrapper"

  sgs = {
    primary = {
      name        = "three-tier-primary-sg"
      description = "Security group for primary region"
      vpc_id      = module.vpc.vpc_ids["primary"]
      environment = "prod"

      ingress_rules = [
        { from_port = 80, to_port = 80, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
        { from_port = 443, to_port = 443, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
        { from_port = 3000, to_port = 3000, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
        { from_port = 3306, to_port = 3306, protocol = "tcp", cidr_blocks = [var.vpcs["primary"].cidr_block] }
      ]

      egress_rules = [
        { from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = ["0.0.0.0/0"] }
      ]
    }

    secondary = {
      name        = "three-tier-secondary-sg"
      description = "Security group for secondary region"
      vpc_id      = module.vpc.vpc_ids["secondary"]
      environment = "prod"

      ingress_rules = [
        { from_port = 80, to_port = 80, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
        { from_port = 443, to_port = 443, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
        { from_port = 3000, to_port = 3000, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
        { from_port = 3306, to_port = 3306, protocol = "tcp", cidr_blocks = [var.vpcs["secondary"].cidr_block] }
      ]

      egress_rules = [
        { from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = ["0.0.0.0/0"] }
      ]
    }
  }
}

# ─── ALB Primary (single-instance wrapper) ────────────────────
module "alb_primary" {
  source = "../../Terraform-wrappers/wrappers/alb-wrapper"

  name                       = var.primary_alb_name
  internal                   = var.primary_alb_internal
  environment                = var.primary_alb_environment
  vpc_id                     = module.vpc.vpc_ids["primary"]
  subnet_ids                 = data.aws_subnets.primary_public.ids
  sg_id                      = module.sg.sg_ids["primary"]
  enable_deletion_protection = false

  target_groups = var.primary_alb_target_groups
  listeners     = var.primary_alb_listeners
}

# ─── ALB Secondary (single-instance wrapper) ──────────────────
module "alb_secondary" {
  source = "../../Terraform-wrappers/wrappers/alb-wrapper"

  aws_region                 = var.secondary_region
  name                       = var.secondary_alb_name
  internal                   = var.secondary_alb_internal
  environment                = var.secondary_alb_environment
  vpc_id                     = module.vpc.vpc_ids["secondary"]
  subnet_ids                 = data.aws_subnets.secondary_public.ids
  sg_id                      = module.sg.sg_ids["secondary"]
  enable_deletion_protection = false

  target_groups = var.secondary_alb_target_groups
  listeners     = var.secondary_alb_listeners
}

# ─── IAM (multi-resource wrapper) ─────────────────────────────
module "iam" {
  source = "../../Terraform-wrappers/wrappers/iam-wrapper"

  roles              = var.iam_roles
  policies           = var.iam_policies
  policy_attachments = var.iam_policy_attachments
}

# ─── ECR (map-based wrapper) ──────────────────────────────────
module "ecr" {
  source       = "../../Terraform-wrappers/wrappers/ecr-wrapper"
  repositories = var.ecr_repositories
}

# ─── ECS (map-based wrapper) ──────────────────────────────────
module "ecs" {
  source = "../../Terraform-wrappers/wrappers/ecs-wrapper"

  clusters     = var.ecs_clusters
  ecs_services = var.ecs_services
}

# ─── CloudFront (map-based wrapper) ───────────────────────────
module "cloudfront" {
  source        = "../../Terraform-wrappers/wrappers/cloudfront-wrapper"
  distributions = var.cloudfront_distributions
}

# ─── S3 Frontend (single-instance wrapper) ────────────────────
module "s3_frontend" {
  source = "../../Terraform-wrappers/wrappers/s3-wrapper"

  bucket              = var.s3_bucket_name
  force_destroy       = var.s3_force_destroy
  versioning          = var.s3_versioning
  cors_rule           = var.s3_cors_rule
  bucket_policy       = var.s3_bucket_policy
  public_access_block = var.s3_public_access_block
  ownership_controls  = var.s3_ownership_controls
  acl                 = var.s3_acl
  server_side_encryption = var.s3_server_side_encryption
}

# ─── RDS Global (kept as local sub-module — no wrapper) ───────
module "rds_global" {
  source = "./rds-global"

  providers = {
    aws           = aws
    aws.secondary = aws.secondary
  }

  primary_vpc_id     = module.vpc.vpc_ids["primary"]
  primary_subnets    = data.aws_subnets.primary_private.ids
  primary_vpc_cidr   = var.vpcs["primary"].cidr_block
  primary_sg_id      = module.sg.sg_ids["primary"]

  secondary_vpc_id   = module.vpc.vpc_ids["secondary"]
  secondary_subnets  = data.aws_subnets.secondary_private.ids
  secondary_vpc_cidr = var.vpcs["secondary"].cidr_block
  secondary_sg_id    = module.sg.sg_ids["secondary"]
}
