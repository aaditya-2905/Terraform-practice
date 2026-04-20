output "cloudfront_domain_name" {
  description = "value of my cloudfront domain name"
  value       = module.cdn.cloudfront_distribution_domain_name
}

output "cloudfront_id" {
  description = "value of my cloudfront id"
  value       = module.cdn.cloudfront_distribution_id
}

output "cloudfront_arn" {
  description = "value of my cloudfront arn"
  value       = module.cdn.cloudfront_distribution_arn
}

output "cloudfront_hosted_zone_id" {
  description = "value of my cloudfront hosted zone id"
  value       = module.cdn.cloudfront_distribution_hosted_zone_id
}
