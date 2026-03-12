output "Cloudfront-url" {
  description = "The URL of the CloudFront distribution"
  value       = aws_cloudfront_distribution.static_web_cdn.domain_name
}

output "Web-url" {
  description = "The URL of the static website"
  value       = "https://${aws_cloudfront_distribution.static_web_cdn.domain_name}"
}

output "cloudfront_distribution_id" {
  description = "CloudFront Distribution ID"
  value       = aws_cloudfront_distribution.static_web_cdn.id
}

output "S3-bucket" {
  description = "Our website storing s3-bucket"
  value = aws_s3_bucket.tf-bucket-static-web
}   