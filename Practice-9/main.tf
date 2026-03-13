module "vpc" {
  source   = "terraform-aws-modules/vpc/aws"
  for_each = length(var.Vpc) > 0 ? { for idx, vpc in var.Vpc : idx => vpc } : {}
  name     = each.value.Vpc_name
  cidr     = each.value.Vpc_cidr
  #   enable_nat_gateway = true
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_subnet" "vpc_1_subnet" {
  vpc_id                  = module.vpc["0"].vpc_id
  cidr_block              = var.Vpc_1_subnet
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "vpc_2_subnet" {
  vpc_id                  = module.vpc["1"].vpc_id
  cidr_block              = var.Vpc_2_subnet
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_vpc_peering_connection" "vpc_peering" {
  vpc_id      = module.vpc["0"].vpc_id
  peer_vpc_id = module.vpc["1"].vpc_id
}

resource "aws_vpc_peering_connection_accepter" "vpc_peering_accepter" {
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
  auto_accept               = true
}

resource "aws_route_table" "route_table_vpc_1" {
  vpc_id = module.vpc["0"].vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Igw-1.id
  }

  route {
    cidr_block                = var.Vpc[1].Vpc_cidr
    vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
  }
}

resource "aws_route_table" "route_table_vpc_2" {
  vpc_id = module.vpc["1"].vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Igw-2.id
  }

  route {
    cidr_block                = var.Vpc[0].Vpc_cidr
    vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
  }
}

resource "aws_route_table_association" "route_table_association_vpc_1" {
  subnet_id      = aws_subnet.vpc_1_subnet.id
  route_table_id = aws_route_table.route_table_vpc_1.id

  depends_on = [aws_route_table.route_table_vpc_1]
}

resource "aws_route_table_association" "route_table_association_vpc_2" {
  subnet_id      = aws_subnet.vpc_2_subnet.id
  route_table_id = aws_route_table.route_table_vpc_2.id

  depends_on = [aws_route_table.route_table_vpc_2]
}
resource "aws_internet_gateway" "Igw-1" {
  vpc_id = module.vpc["0"].vpc_id

  tags = {
    Name = "main"
  }
}

resource "aws_internet_gateway" "Igw-2" {
  vpc_id = module.vpc["1"].vpc_id

  tags = {
    Name = "main"
  }
}

resource "aws_security_group" "Vpc1_peering_sg" {
  name        = "vpc1-peering-sg"
  description = "Security group for VPC peering instances"
  vpc_id      = module.vpc["0"].vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.Vpc["1"].Vpc_cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "Vpc2_peering_sg" {
  name        = "vpc2-peering-sg"
  description = "Security group for VPC peering instances"
  vpc_id      = module.vpc["1"].vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.Vpc["0"].Vpc_cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "vpc_1_instance" {
  ami                         = "ami-0b6c6ebed2801a5cb"
  instance_type               = "t3.micro"
  key_name                    = "IQ"
  subnet_id                   = aws_subnet.vpc_1_subnet.id
  vpc_security_group_ids      = [aws_security_group.Vpc1_peering_sg.id]
  associate_public_ip_address = true
  tags = {
    Name = "vpc-1-instance"
  }
}

resource "aws_instance" "vpc_2_instance" {
  ami                         = "ami-0b6c6ebed2801a5cb"
  instance_type               = "t3.micro"
  key_name                    = "IQ"
  subnet_id                   = aws_subnet.vpc_2_subnet.id
  vpc_security_group_ids      = [aws_security_group.Vpc2_peering_sg.id]
  associate_public_ip_address = true
  tags = {
    Name = "vpc-2-instance"
  }
}
