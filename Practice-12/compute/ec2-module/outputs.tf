output "ec2_instance_id" {
  value = aws_instance.this.id
}

output "ec2_instance_public_ip" {
  value = aws_instance.this.public_ip
}