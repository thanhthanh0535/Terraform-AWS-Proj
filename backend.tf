# backend.tf
terraform {
  backend "s3" {
    bucket         = "devops-vpc-tfstate-<your-aws-account-id>"
    key            = "vpc/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}