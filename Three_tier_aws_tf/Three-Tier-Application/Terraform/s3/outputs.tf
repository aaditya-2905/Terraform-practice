output "s3_arn" {
  description = "value of my s3 arn"
  value       = module.s3.s3_bucket_arn
}

output "s3_bucket_id" {
  description = "value of my s3 bucket id"
  value       = module.s3.s3_bucket_id
}

output "s3_bucket_domain_name" {
  description = "value of my s3 bucket domain name"
  value       = module.s3.s3_bucket_bucket_regional_domain_name
}
