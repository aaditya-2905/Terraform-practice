resource "aws_rds_global_cluster" "this" {
  global_cluster_identifier = "global-db"
  engine                    = "aurora-mysql"
  engine_version            = "8.0.mysql_aurora.3.04.0"
  storage_encrypted         = true
}

module "aurora_primary" {
  source = "terraform-aws-modules/rds-aurora/aws"

  name           = "three-tier-app-aurora-primary"
  engine         = "aurora-mysql"
  engine_version = "8.0.mysql_aurora.3.04.0"

  cluster_instance_class = "db.t3.medium"
  instances              = { one = {} }

  vpc_id  = var.primary_vpc_id
  subnets = var.primary_subnets

  security_group_ingress_rules = {
    ingress_ecs = {
      from_port                    = 3306
      to_port                      = 3306
      ip_protocol                  = "tcp"
      referenced_security_group_id = var.primary_sg_id
    }
  }

  storage_encrypted           = true
  global_cluster_identifier   = aws_rds_global_cluster.this.id
  manage_master_user_password = true
  backup_retention_period     = 7
}

module "aurora_secondary" {
  source = "terraform-aws-modules/rds-aurora/aws"

  providers = { aws = aws.secondary }

  name           = "three-tier-app-aurora-secondary"
  engine         = "aurora-mysql"
  engine_version = "8.0.mysql_aurora.3.04.0"

  cluster_instance_class = "db.t3.medium"
  instances              = { one = {} }

  vpc_id  = var.secondary_vpc_id
  subnets = var.secondary_subnets

  security_group_ingress_rules = {
    ingress_ecs = {
      from_port                    = 3306
      to_port                      = 3306
      ip_protocol                  = "tcp"
      referenced_security_group_id = var.secondary_sg_id
    }
  }

  storage_encrypted         = true
  global_cluster_identifier = aws_rds_global_cluster.this.id

  depends_on = [module.aurora_primary]
}
