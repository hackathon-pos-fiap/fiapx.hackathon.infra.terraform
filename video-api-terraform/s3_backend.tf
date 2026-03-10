terraform {
  backend "s3" {
    bucket  = "fiapx-terraform-state-lgrando"
    key     = "infra-video-api/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}