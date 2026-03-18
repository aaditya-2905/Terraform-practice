resource "aws_instance" "this" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  security_groups = var.security_group_ids

  user_data = var.user_data

  tags = {
    Name = var.ec2_name
  }
}
