variable "vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "vpc_name" {
  type    = string
  default = "production-vpc"
}

variable "ami_id" {
  type    = string
  default = "ami-0b6c6ebed2801a5cb"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "ec2_name" {
  type    = string
  default = "production-ec2"
}

variable "public_subnet_cidr_block" {
  type    = string
  default = "10.0.1.0/24"
}

variable "availability_zones" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "security_group_name" {
  type    = string
  default = "production_sg"
}

variable "ingress_rule" {
  type = map(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = {
    "http" = {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
     "ssh" = {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

variable "egress_rule" {
  type = map(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
   }))
  default = {
    "all_traffic" = {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

variable "bucket_name" {
  type = string
  default = "terraformpracticebucket2901"
}