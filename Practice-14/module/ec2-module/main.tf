resource "aws_instance" "web" {
  count = var.instance_count

  ami           = var.ec2_ami
  instance_type = var.instance_type

  tags = {
    Name        = "${var.environment}-web-${count.index}"
    Environment = var.environment
  }
}