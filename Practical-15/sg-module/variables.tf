variable "sg_ingress_rule" {
  description = "ingress rule for sg"
  type = map(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))
}

variable "sg_egress_rule" {
  description = "egress rule for sg"
  type = map(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))
}

variable "vpc_id" {
    description = "vpc id for sg"
    type = string
}

