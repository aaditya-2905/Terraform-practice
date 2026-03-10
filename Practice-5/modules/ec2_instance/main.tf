provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "practical-5" {
  ami = var.ami
  instance_type = var.instance_type
}
