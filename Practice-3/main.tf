terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.35.1"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "Aadityasinh" {
  ami = "ami-0b6c6ebed2801a5cb"
  instance_type = "t3.micro"
  key_name = "IQ"
  subnet_id = "subnet-0bdb0e280f1daf8ee"
}

# resource "aws_s3_bucket" "s3-bucket" {
#   bucket = "terraform-practice-3-bucket"
# }

# resource "aws_dynamodb_table" "terraform-practice-3" {
#   name = "terraform-practice-3"
#   billing_mode = "PAY_PER_REQUEST"
#   hash_key = "LockID"

#   attribute {
#     name = "LockID"
#     type = "S"
#   }
# }