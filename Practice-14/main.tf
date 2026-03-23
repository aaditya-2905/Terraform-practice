resource "aws_dynamodb_table" "tf_lock_table" {
  name = "tf-workspace-lock-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

module "ec2" {
  source = "./module/ec2-module"

  instance_count = terraform.workspace == "prod" ? 2 : 1
  instance_type  = terraform.workspace == "prod" ? "t2.small" : "t2.micro"

  environment = terraform.workspace
}

