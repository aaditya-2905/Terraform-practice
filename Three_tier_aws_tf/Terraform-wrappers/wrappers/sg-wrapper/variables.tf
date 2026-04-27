variable "aws_region" {
  description = "AWS region where resources will be deployed"
  type        = string
  default     = "us-east-1"
}

variable "common_tags" {
  description = "Common tags to apply to all security groups"
  type        = map(string)
  default     = {}
}

variable "sgs" {
  description = "Map of Security Group configurations"
  type = map(object({
    name        = string
    description = optional(string)
    vpc_id      = string
    environment = optional(string, "prod")
    ingress_rules = optional(list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = optional(list(string))
      security_groups = optional(list(string))
    })))
    egress_rules = optional(list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = optional(list(string))
    })))
    tags = optional(map(string))
  }))
  default = {}

  validation {
    condition = alltrue([
      for k, v in var.sgs : length(v.name) > 0 && length(v.name) <= 255
    ])
    error_message = "Security group name must be between 1 and 255 characters."
  }
}
