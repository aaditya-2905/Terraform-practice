provider "aws" {
  region = var.region
}

resource "aws_key_pair" "practice-4" {
  key_name   = "aws-practice-4"
  public_key = file("/home/aadityasinh.zala/.ssh/id_rsa.pub")
}

resource "aws_vpc" "Demo_vpc" {
  cidr_block = var.cidr
}

resource "aws_subnet" "sub-1" {
  vpc_id                  = aws_vpc.Demo_vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "ig1" {
  vpc_id = aws_vpc.Demo_vpc.id
}

resource "aws_route_table" "rt-1" {
  vpc_id = aws_vpc.Demo_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig1.id
  }
}

resource "aws_route_table_association" "rt-sub" {
  subnet_id      = aws_subnet.sub-1.id
  route_table_id = aws_route_table.rt-1.id
}

resource "aws_security_group" "sg-1" {
  name   = "demo-sg"
  vpc_id = aws_vpc.Demo_vpc.id

  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "practice-4" {
  ami                    = "ami-0b6c6ebed2801a5cb"
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.practice-4.key_name
  vpc_security_group_ids = [aws_security_group.sg-1.id]
  subnet_id              = aws_subnet.sub-1.id

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("/home/aadityasinh.zala/.ssh/id_rsa")
    host        = self.public_ip
  }

  provisioner "file" {
    source      = "app.py"
    destination = "/home/ubuntu/app.py"
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'hello from the remote instance..'",
      "sudo apt update -y",
      "sudo apt install python3-flask -y",
      "sudo python3 /home/ubuntu/app.py &"
    ]
  }
}
