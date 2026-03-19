module "vpc" {
  source = "./network"
}

module "ec2" {
  source = "./compute"
}

