variable "Vpc" {
  type = list(object({
    Vpc_name = string
    Vpc_cidr = string
    environment = string
  }))
  default = [
    {
      Vpc_name = "vpc-1"
      Vpc_cidr = "10.0.0.0/24"
      environment = "dev"
    },
    {
      Vpc_name = "vpc-2"
      Vpc_cidr = "10.1.0.0/24"
      environment = "prod"
    }
  ]
}

variable "Vpc_1_subnet" {
  type = string
  default = "10.0.0.0/28"
}

variable "Vpc_2_subnet" {
  type = string
  default = "10.1.0.0/28"
}