variable "aws_region" {
  description = "AWS region where resources will be deployed"
  type        = string
  default     = "us-east-1"
}

variable "common_tags" {
  description = "Common tags to apply to all CloudFront distributions"
  type        = map(string)
  default     = {}
}

variable "distributions" {
  description = "Map of CloudFront distribution configurations"
  type = map(object({
    aliases                 = optional(list(string), [])
    origin                  = optional(any)
    origin_group            = optional(any)
    origin_access_control   = optional(any)
    default_cache_behavior  = optional(any)
    ordered_cache_behavior  = optional(any)
    custom_error_response   = optional(any)
    restrictions            = optional(any)
    viewer_certificate      = optional(any)
    response_headers_policy = optional(any)
    custom_headers          = optional(any)
    logging_config          = optional(any)
    log_delivery            = optional(any)
    vpc_origin              = optional(any)
    tags                    = optional(map(string), {})
  }))
  default = {}
}
