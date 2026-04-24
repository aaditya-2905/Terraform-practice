locals {
  # Merge common tags with user tags
  tags = merge(
    var.common_tags,
    var.tags,
    {
      created_by = "terraform"
      module     = "s3-wrapper"
    }
  )
}

module "s3" {
  source = "aaditya-2905/s3/aws"

  bucket        = var.bucket
  bucket_prefix = var.bucket_prefix
  force_destroy = var.force_destroy

  tags = local.tags

  bucket_policy       = var.bucket_policy
  public_access_block = var.public_access_block

  versioning         = var.versioning
  cors_rule          = var.cors_rule
  ownership_controls = var.ownership_controls
  acl                = var.acl

  server_side_encryption = var.server_side_encryption

  replication_configuration = var.replication_configuration
  lifecycle_rule            = var.lifecycle_rule
}

output "bucket_id" {
  description = "The name of the S3 bucket"
  value       = module.s3.bucket_id
}

output "bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = module.s3.bucket_arn
}


