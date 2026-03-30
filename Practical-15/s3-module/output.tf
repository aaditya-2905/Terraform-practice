output "s3_bucket_arn" {
  description = "arn for s3 bucket"
  value       = aws_s3_bucket.s3_bucket.arn
}
