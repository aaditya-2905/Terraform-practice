locals {
  # Map-based configuration for ECR repositories
  repositories = var.repositories

  # Common tags for all resources
  common_tags = merge(
    var.common_tags,
    {
      created_by = "terraform"
      module     = "ecr-wrapper"
    }
  )
}

module "repository" {
  for_each = local.repositories

  source = "aaditya-2905/ecr/aws"

  name              = each.value.name
  repository_type   = each.value.repository_type
  force_delete      = each.value.force_delete
  encryption_config = each.value.encryption_config
  region            = coalesce(each.value.region, var.aws_region)

  image_scanning_config = each.value.image_scanning_config

  repository_policy = each.value.repository_policy
  lifecycle_policy  = each.value.lifecycle_policy

  tags = merge(
    local.common_tags,
    each.value.tags,
    {
      Name = each.value.name
    }
  )
}

output "repository_urls" {
  description = "Repository URLs of created ECR repositories"
  value       = { for k, v in module.repository : k => v.repository_url }
}

output "repository_arns" {
  description = "ARNs of created ECR repositories"
  value       = { for k, v in module.repository : k => v.repository_arn }
}
