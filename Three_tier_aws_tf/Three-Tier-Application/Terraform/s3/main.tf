module "s3" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket_prefix = "three-tier-tf-"

  object_ownership         = "BucketOwnerEnforced"
  control_object_ownership = true

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  versioning = {
    enabled = true
  }

  tags = {
    Environment = "dev"
    Region      = var.region
  }
}
