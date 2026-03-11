provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "pr_bucket" {
  count = 2
  # count is used to create multiple resources based on a number. It will create resources for each number from 0 to count-1.
  bucket = var.bucket_names_list[count.index]
  tags = {
    Name        = "pr-bucket-day-6"
    Environment = "dev"
  }
}

resource "aws_s3_bucket" "pr_bucket_1" {
  for_each = var.bucket_names_set
  # for each is used to create resources based on a set or map. It will create resources for each element in the set or map.
  bucket = each.key
  tags = {
    Name        = "pr-bucket-day-6"
    Environment = "prod"
  }

  depends_on = [aws_s3_bucket.pr_bucket]
  # it will create the bucket with dev environment first and then it will create
  # the bucket with prod environment. 
  # It will not create the bucket with prod environment if 
  # the bucket with dev environment is not created.
}

resource "aws_security_group" "pr_security_group" {
  name        = "pr-security-group"
  description = "Security group for practice-6"
  vpc_id      = var.vpc_id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "pr_instance" {
  ami           = "ami-0b6c6ebed2801a5cb"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.pr_security_group.name]
  
  lifecycle {
    prevent_destroy = true
    create_before_destroy = true

    #lifecycle block is used to control the lifecycle of the resource.
    # prevent_destroy is used to prevent the resource from being destroyed.
    # It will not allow the resource to be destroyed even if the resource is removed from the configuration.
    # create_before_destroy is used to create the new resource before destroying the old resource.
    # It will create the new resource first and then it will destroy the old resource. 
    # It is used to avoid downtime when the resource is being replaced
  }
}