terraform {
  backend "s3" {
    bucket  = "fiapx-terraform-state-lgrando"
    key     = "eks/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}