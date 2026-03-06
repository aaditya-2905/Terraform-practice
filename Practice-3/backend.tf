terraform {
  backend "s3" {
    bucket = "terraform-practice-3-bucket"
    region = "us-east-1"
    key = "aadityasinh/terraform.tfstate"
    dynamodb_table = "terraform-practice-3"
  }
}