variable "aws_region" {
  description = "AWS region where resources will be deployed"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (e.g. dev, prod)"
  type        = string
}

variable "name" {
  description = "The name of the ALB"
  type        = string
}

variable "internal" {
  description = "If true, the LB will be internal"
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "The VPC ID where the ALB and Target Groups will be created"
  type        = string
}

variable "subnet_ids" {
  description = "A list of subnet IDs to attach to the LB"
  type        = list(string)
}

variable "sg_id" {
  description = "Security Group ID for ALB"
  type        = string
}

variable "enable_deletion_protection" {
  description = "If true, deletion of the load balancer will be disabled via the AWS API"
  type        = bool
  default     = false
}

variable "target_groups" {
  description = "Map of target group configurations"
  type = map(object({
    port                 = optional(number, 80)
    protocol             = optional(string, "HTTP")
    target_type          = optional(string, "instance")
    deregistration_delay = optional(number, 300)
    health_check = optional(object({
      enabled             = optional(bool, true)
      interval            = optional(number, 30)
      path                = optional(string, "/")
      port                = optional(string, "traffic-port")
      protocol            = optional(string, "HTTP")
      timeout             = optional(number, 5)
      healthy_threshold   = optional(number, 3)
      unhealthy_threshold = optional(number, 3)
      matcher             = optional(string, "200")
    }), {})
  }))
  default = {}
}

variable "listeners" {
  description = "Map of listener configurations"
  type = map(object({
    port             = optional(number, 80)
    protocol         = optional(string, "HTTP")
    target_group_key = string
    ssl_policy       = optional(string)
    certificate_arn  = optional(string)
  }))
  default = {}
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
