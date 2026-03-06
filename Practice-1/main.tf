provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "practice-1" {
  ami = "ami-0b6c6ebed2801a5cb"
  instance_type = "t3.micro"
  key_name = "IQ"
  subnet_id = "subnet-0bdb0e280f1daf8ee"
}
