resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
  tags = { Name = var.vpc_name }
}

resource "aws_subnet" "public_1" {
  vpc_id = aws_vpc.this.id
  cidr_block = var.public_subnet_cidr[0]
  availability_zone = var.availability_zones[0]
  map_public_ip_on_launch = true
}

resource "aws_subnet" "public_2" {
  vpc_id = aws_vpc.this.id
  cidr_block = var.public_subnet_cidr[1]
  availability_zone = var.availability_zones[1]
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private_1" {
  vpc_id = aws_vpc.this.id
  cidr_block = var.private_subnet_cidr[0]
  availability_zone = var.availability_zones[0]
}

resource "aws_subnet" "private_2" {
  vpc_id = aws_vpc.this.id
  cidr_block = var.private_subnet_cidr[1]
  availability_zone = var.availability_zones[1]
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "pub1" {
  subnet_id = aws_subnet.public_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "pub2" {
  subnet_id = aws_subnet.public_2.id
  route_table_id = aws_route_table.public_rt.id
}

# ✅ FIXED EIP
resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  subnet_id     = aws_subnet.public_1.id
  allocation_id = aws_eip.nat_eip.id
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
}

resource "aws_route_table_association" "pvt1" {
  subnet_id = aws_subnet.private_1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "pvt2" {
  subnet_id = aws_subnet.private_2.id
  route_table_id = aws_route_table.private_rt.id
}