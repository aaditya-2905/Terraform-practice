variable "vpc_cidr" {
  type = string
}

variable "vpc_tags" {
  type = map(string)
}

variable "public_subnet_cidrs" {
  type = list(string)
}