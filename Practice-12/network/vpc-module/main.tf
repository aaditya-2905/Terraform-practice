resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr_block
  
    tags = {
        Name = var.vpc_name
    }
}

resource "aws_subnet" "this" {
  count                   = length(var.public_subnet_cidr_blocks)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidr_blocks[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true
  
    tags = {
        Name = "${var.vpc_name}-public-subnet-${count.index + 1}"
    }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_route_table_association" "this" {
  count = length(aws_subnet.this)

  subnet_id      = aws_subnet.this[count.index].id
  route_table_id = aws_route_table.this.id
}

resource "aws_route_table" "this" {
    vpc_id = aws_vpc.this.id
    
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.this.id
    }
}
