variable "s3-bucket-name" {
  description = "The name of the S3 bucket"
  default = "my-tf-bucket-static-web"
}

variable "s3-bucket-region" {
  description = "The AWS region where the S3 bucket will be created"
  default = "us-east-1"
}

variable "domain_name" {
    description = "The domain name for the ACM certificate"
    default = "aadityasinhzala.in"
}

variable "Environment" {
  description = "The environment type"
  default = "production"
}