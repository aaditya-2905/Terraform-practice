module "vpc" {
  source = "./network"
}

module "compute" {
  source = "./compute"

  vpc_id         = module.vpc.vpc_id
  pub_subnet_ids = module.vpc.pub_subnet_ids
  pvt_subnet_ids = module.vpc.priv_subnet_ids

  security_group_for_pub = var.security_group_for_pub
  security_group_for_pvt = var.security_group_for_pvt
}