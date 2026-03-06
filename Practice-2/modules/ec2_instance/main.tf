provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami = var.ami-value
  instance_type = var.instance-type
  subnet_id = var.subnetid-value
}