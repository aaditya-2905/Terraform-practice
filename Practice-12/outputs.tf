output "vpc_id" {
  value = module.vpc.vpc_id
}

output "subnet_id" {
  value = module.vpc.subnet_id
}

output "ec2_instance_id" {
  value = module.ec2.ec2_instance_id
}

output "ec2_instance_public_ip" {
  value = module.ec2.ec2_instance_public_ip
}