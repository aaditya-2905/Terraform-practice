variable "aws_region" {
  description = "AWS region where resources will be deployed"
  type        = string
  default     = "us-east-1"
}

variable "common_tags" {
  description = "Common tags to apply to all VPCs"
  type        = map(string)
  default     = {}
}

variable "vpcs" {
  description = "Map of VPC configurations"
  type = map(object({
    name                       = string
    cidr_block                 = string
    public_subnet_cidr_blocks  = optional(list(string), [])
    private_subnet_cidr_blocks = optional(list(string), [])
    availability_zones         = optional(list(string), [])
    enable_nat_gateway         = optional(bool, false)
    single_nat_gateway         = optional(bool, false)
    enable_dns_hostnames       = optional(bool, true)
    enable_dns_support         = optional(bool, true)
    tags                       = optional(map(string), {})
  }))
  default = {}

  validation {
    condition = alltrue([
      for k, v in var.vpcs : can(cidrhost(v.cidr_block, 0))
    ])
    error_message = "cidr_block must be a valid CIDR block."
  }
}
