locals {
  # Merge defaults with user inputs
  sgs = {
    for key, config in var.sgs : key => merge(
      {
        description   = key
        ingress_rules = []
        egress_rules = [
          {
            from_port   = 0
            to_port     = 0
            protocol    = "-1"
            cidr_blocks = ["0.0.0.0/0"]
          }
        ]
        tags = {}
      },
      config
    )
  }

  # Common tags for all resources
  common_tags = merge(
    var.common_tags,
    {
      created_by = "terraform"
      module     = "sg-wrapper"
    }
  )
}

module "sg" {
  for_each = local.sgs

  source = "aaditya-2905/sg/aws"

  vpc_id        = each.value.vpc_id
  ingress_rules = each.value.ingress_rules
  egress_rules  = each.value.egress_rules
  environment   = each.value.environment

}

output "sg_ids" {
  description = "IDs of created Security Groups"
  value       = { for k, v in module.sg : k => v.sg_id }
}
