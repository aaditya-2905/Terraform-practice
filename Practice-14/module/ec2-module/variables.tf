variable "instance_count" {}
variable "instance_type" {}
variable "environment" {}

variable "ec2_ami" {
  description = "AMI id for ec2 instance"
  default = "ami-0b6c6ebed2801a5cb"
}