locals {
  # Use provided AMI
  ami = var.ami

  # Common tags for all resources
  common_tags = merge(
    var.tags,
    {
      created_by  = "terraform"
      module      = "ec2-wrapper"
      environment = var.environment
    }
  )
}

module "ec2" {
  for_each = var.create_instances ? toset(var.instance_names) : []

  source = "aaditya-2905/ec2/aws"

  environment   = var.environment
  ami           = local.ami
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  sg_id         = var.sg_id

  tags = local.common_tags
}

output "instance_ids" {
  description = "IDs of created EC2 instances"
  value       = { for k, v in module.ec2 : k => v.instance_id }
}

output "instance_private_ips" {
  description = "Private IPs of created EC2 instances"
  value       = { for k, v in module.ec2 : k => v.private_ip }
}
