module "vpc" {
  source = "./network/vpc-module"

  vpc_name                  = var.vpc_name
  vpc_cidr_block            = var.vpc_cidr_block
  public_subnet_cidr_blocks = [var.public_subnet_cidr_block]
  availability_zones        = var.availability_zones

}

module "security_group" {
  source       = "./network/security-group"
  vpc_id       = module.vpc.vpc_id
  name         = var.security_group_name
  ingress_rule = var.ingress_rule
egress_rule  = var.egress_rule
}

module "ec2" {
  source = "./compute/ec2-module"

  subnet_id          = module.vpc.subnet_id[0]
  security_group_ids = [module.security_group.security_group_id]
  ami_id             = var.ami_id
  instance_type      = var.instance_type
  ec2_name           = var.ec2_name

}

module "s3_bucket" {
  source = "./data/s3-module"
  bucket_name = var.bucket_name
}