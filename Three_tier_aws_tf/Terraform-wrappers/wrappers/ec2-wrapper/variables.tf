variable "aws_region" {
  description = "AWS region where resources will be deployed"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "subnet_id" {
  description = "The VPC Subnet ID to launch in"
  type        = string
}

variable "sg_id" {
  description = "Security group ID for the instances"
  type        = string
}

variable "instance_names" {
  description = "List of names for the instances to create"
  type        = list(string)
  default     = ["web-1"]
}

variable "instance_type" {
  description = "The type of instance to start"
  type        = string
  default     = "t3.micro"
}

variable "ami" {
  description = "The AMI to use for the instances. If not provided, a default will be used."
  type        = string
  default     = null
}

variable "create_instances" {
  description = "Whether to create the instances"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Additional tags for all resources"
  type        = map(string)
  default     = {}
}
