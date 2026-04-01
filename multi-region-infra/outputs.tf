output "vpc_mumbai_id" {
  value = module.vpc_mumbai.vpc_id
}

output "vpc_us_id" {
  value = module.vpc_us.vpc_id
}

output "alb_mumbai_dns_name" {
  value = module.alb_mumbai.alb_dns_name
}

output "alb_us_dns_name" {
  value = module.alb_us.alb_dns_name
}

output "ec2_mumbai_public_ip" {
  value = module.ec2_mumbai.public_ips
}

output "ec2_us_public_ip" {
  value = module.ec2_us.public_ips
}

output "sg_mumbai_id" {
  value = module.sg_mumbai.sg_id
}

output "sg_us_id" {
  value = module.sg_us.sg_id
}

output "public_subnet_mumbai_id" {
  value = module.vpc_mumbai.public_subnet_ids
}

output "public_subnet_us_id" {
  value = module.vpc_us.public_subnet_ids
}

output "private_subnet_mumbai_id" {
  value = module.vpc_mumbai.private_subnet_ids
}

output "private_subnet_us_id" {
  value = module.vpc_us.private_subnet_ids
}
