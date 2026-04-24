locals {
  # Map-based configuration for CloudFront distributions
  distributions = var.distributions

  # Common tags for all resources
  common_tags = merge(
    var.common_tags,
    {
      created_by = "terraform"
      module     = "cloudfront-wrapper"
    }
  )
}

module "distribution" {
  for_each = local.distributions

  source = "aaditya-2905/cloudfront/aws"

  aliases                 = each.value.aliases
  origin                  = each.value.origin
  origin_group            = each.value.origin_group
  origin_access_control   = each.value.origin_access_control
  default_cache_behavior  = each.value.default_cache_behavior
  ordered_cache_behavior  = each.value.ordered_cache_behavior
  custom_error_response   = each.value.custom_error_response
  restrictions            = each.value.restrictions
  viewer_certificate      = each.value.viewer_certificate
  response_headers_policy = each.value.response_headers_policy
  custom_headers          = each.value.custom_headers
  logging_config          = each.value.logging_config
  log_delivery            = each.value.log_delivery
  vpc_origin              = each.value.vpc_origin

  tags = merge(
    local.common_tags,
    each.value.tags
  )
}

output "distribution_ids" {
  description = "IDs of created CloudFront distributions"
  value       = { for k, v in module.distribution : k => v.distribution_id }
}

output "distribution_domain_names" {
  description = "Domain names of created CloudFront distributions"
  value       = { for k, v in module.distribution : k => v.domain_name }
}
