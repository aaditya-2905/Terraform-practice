variable "aws_region" {
  description = "AWS region where resources will be deployed"
  type        = string
  default     = "us-east-1"
}

variable "common_tags" {
  description = "Common tags to apply to the S3 bucket"
  type        = map(string)
  default     = {}
}

variable "bucket" {
  description = "Name of the S3 bucket"
  type        = string
  default     = null
}

variable "bucket_prefix" {
  description = "Creates a unique bucket name beginning with the specified prefix"
  type        = string
  default     = null
}

variable "force_destroy" {
  description = "Boolean that indicates all objects (including any locked objects) should be deleted from the bucket so that the bucket can be destroyed without error"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "bucket_policy" {
  description = "The text of the policy as configured by an S3 bucket policy"
  type        = string
  default     = null
}

variable "public_access_block" {
  description = "Public access block configuration"
  type = object({
    block_public_acls       = optional(bool, true)
    block_public_policy     = optional(bool, true)
    ignore_public_acls      = optional(bool, true)
    restrict_public_buckets = optional(bool, true)
  })
  default = {}
}

variable "versioning" {
  description = "Enable versioning on the bucket"
  type = object({
    status = string
  })
  default = null
}

variable "cors_rule" {
  description = "CORS rule configuration"
  type = list(object({
    allowed_headers = optional(list(string), [])
    allowed_methods = list(string)
    allowed_origins = list(string)
    expose_headers  = optional(list(string), [])
    max_age_seconds = optional(number, 3000)
  }))
  default = []
}

variable "ownership_controls" {
  description = "Object Ownership configuration"
  type = object({
    object_ownership = string
  })
  default = null
}

variable "acl" {
  description = "The canned ACL to apply"
  type        = string
  default     = "private"
}

variable "server_side_encryption" {
  description = "Server-side encryption configuration"
  type = object({
    sse_algorithm     = string
    kms_master_key_id = optional(string)
  })
  default = null
}

variable "replication_configuration" {
  description = "Replication configuration"
  type = object({
    role  = string
    rules = list(any)
  })
  default = null
}

variable "lifecycle_rule" {
  description = "Lifecycle rules for the bucket"
  type = list(object({
    id                                     = string
    status                                 = string
    prefix                                 = optional(string)
    tags                                   = optional(map(string))
    abort_incomplete_multipart_upload_days = optional(number)
    expiration = optional(object({
      days                         = optional(number)
      expired_object_delete_marker = optional(bool)
    }))
    transition = optional(list(object({
      days          = optional(number)
      storage_class = string
    })))
    noncurrent_version_transition = optional(list(object({
      noncurrent_days = number
      storage_class   = string
    })))
    noncurrent_version_expiration = optional(object({
      noncurrent_days = number
    }))
  }))
  default = []
}
