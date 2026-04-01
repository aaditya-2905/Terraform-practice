variable "vpc_cidr_block" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr_blocks" {
  description = "Public subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidr_blocks" {
  description = "Private subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "mumbai_az" {
  description = "Availability zones for Mumbai region"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b"]
}

variable "us_az" {
  description = "Availability zones for US region"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "ami_id_mumbai" {
  description = "AMI ID for Mumbai region"
  type        = string
  default     = "ami-05d2d839d4f73aafb"
}

variable "ami_id_us" {
  description = "AMI ID for US region"
  type        = string
  default     = "ami-0ec10929233384c7f"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}
