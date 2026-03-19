output "vpc_id" {
  value = aws_vpc.this.id
}

output "pub_subnet_ids" {
  value = [aws_subnet.public_1.id, aws_subnet.public_2.id]
}

output "priv_subnet_ids" {
  value = [aws_subnet.private_1.id, aws_subnet.private_2.id]
}