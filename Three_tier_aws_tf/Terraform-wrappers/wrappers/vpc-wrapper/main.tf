locals {
  vpcs = var.vpcs

  common_tags = merge(
    var.common_tags,
    {
      created_by = "terraform"
      module     = "vpc-wrapper"
    }
  )
}

module "vpc" {
  for_each = local.vpcs

  source = "aaditya-2905/vpc/aws"

  vpc_cidr_block             = each.value.cidr_block
  public_subnet_cidr_blocks  = each.value.public_subnet_cidr_blocks
  private_subnet_cidr_blocks = each.value.private_subnet_cidr_blocks
  availability_zones         = each.value.availability_zones
  enable_nat_gateway         = each.value.enable_nat_gateway
  single_nat_gateway         = each.value.single_nat_gateway

  additional_tags = merge(
    local.common_tags,
    each.value.tags,
    {
      Name = each.value.name
    }
  )
}

output "vpc_ids" {
  description = "IDs of created VPCs"
  value       = { for k, v in module.vpc : k => v.vpc_id }
}
