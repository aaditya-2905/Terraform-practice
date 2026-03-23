terraform {
  backend "s3" {
    bucket = "workspace-practice-tf-state-1"
    region = "us-east-1"
    key = "aadityasinh/terraform.tfstate"
    dynamodb_table = "tf-workspace-lock-table"
  }
}
