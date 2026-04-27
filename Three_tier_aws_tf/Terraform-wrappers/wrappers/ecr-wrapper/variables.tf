variable "aws_region" {
  description = "AWS region where resources will be deployed"
  type        = string
  default     = "us-east-1"
}

variable "common_tags" {
  description = "Common tags to apply to all ECR repositories"
  type        = map(string)
  default     = {}
}

variable "repositories" {
  description = "Map of ECR repository configurations"
  type = map(object({
    name                  = string
    repository_type       = optional(string, "PRIVATE")
    force_delete          = optional(bool, false)
    encryption_config     = optional(any)
    image_scanning_config = optional(any)
    repository_policy     = optional(string)
    lifecycle_policy      = optional(string)
    region                = optional(string)
    tags                  = optional(map(string), {})
  }))
  default = {}
}
