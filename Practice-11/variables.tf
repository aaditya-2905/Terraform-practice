variable "Vpc" {
  type = list(object({
    Vpc_name    = string
    Vpc_cidr    = string
    environment = string
    subnet1 = object({
      subnet_name       = string
      subnet_cidr       = string
      availability_zone = string
    })
    subnet2 = object({
      subnet_name       = string
      subnet_cidr       = string      
      availability_zone = string
    })
  }))
  default = [
    {
      Vpc_name    = "vpc-1"
      Vpc_cidr    = "10.0.0.0/24"
      environment = "dev"
      subnet1 = {
        subnet_name       = "subnet-1"
        subnet_cidr       = "10.0.0.0/26"
        availability_zone = "us-east-1a"
      }
      subnet2 = {
        subnet_name       = "subnet-2"
        subnet_cidr       = "10.0.0.64/26"
        availability_zone = "us-east-1b"
      }
    }
  ]
}

