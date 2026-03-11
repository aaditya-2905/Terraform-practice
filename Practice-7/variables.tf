variable "ingress" {
  type = set(object({
    from_port = number
    to_port = number
    protocol = string
    cidr_blocks = list(string) 
  }))
    default = [
        {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        },
        {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        }
    ]
}

variable "egress" {
  type = set(object({
    from_port = number
    to_port = number
    protocol = string
    cidr_blocks = list(string)
  }))
    default = [
        {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        }
    ]
}

variable "vpc_id" {
  description = "Vpc id"
  default = "vpc-0cf6c7c27dd9ab0d9"
}