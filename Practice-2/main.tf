provider "aws" {
  region = "us-east-1"
}

module "ec2_instance" {
  source = "./modules/ec2_instance"
  ami-value = "ami-031283482dcfced88"
  instance-type = "t3.micro"
  subnetid-value = ""
}