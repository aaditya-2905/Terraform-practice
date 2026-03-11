provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "pr_security_group" {
  name        = "pr-security-group"
  description = "Security group for practice-7"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.ingress
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  # dynamic block are used to create dynamic number of blocks based on the input variable,
  # in this case we are creating dynamic ingress & egress blocks based on the input variable "ingress" & "egress" respectively.

  dynamic "egress" {
    for_each = var.egress
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }
  
}