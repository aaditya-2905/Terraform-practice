variable "vpc_id" {
  type = string
}

variable "pub_subnet_ids" {
  type = list(string)
}

variable "pvt_subnet_ids" {
  type = list(string)
}

variable "security_group_for_pub" {
  type = any
}

variable "security_group_for_pvt" {
  type = any
}