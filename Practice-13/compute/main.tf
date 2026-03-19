# PUBLIC SG
resource "aws_security_group" "public_sg" {
  for_each = var.security_group_for_pub

  name        = each.value.name
  description = each.value.description
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = each.value.ingress
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = each.value.egress
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }
}

# PRIVATE SG
resource "aws_security_group" "private_sg" {
  for_each = var.security_group_for_pvt

  name        = each.value.name
  description = each.value.description
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = each.value.ingress
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = each.value.egress
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }
}

# PUBLIC EC2
resource "aws_instance" "public_ec2" {
  count = 2

  ami           = "ami-0b6c6ebed2801a5cb"
  instance_type = "t3.micro"
  subnet_id     = var.pub_subnet_ids[count.index]

  vpc_security_group_ids = [
    aws_security_group.public_sg["pub_sg"].id
  ]
}

# PRIVATE EC2
resource "aws_instance" "private_ec2" {
  count = 2

  ami           = "ami-0b6c6ebed2801a5cb"
  instance_type = "t3.micro"
  subnet_id     = var.pvt_subnet_ids[count.index]

  vpc_security_group_ids = [
    aws_security_group.private_sg["pvt_sg"].id
  ]
}