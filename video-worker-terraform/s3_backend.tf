terraform {
  backend "s3" {
    bucket  = "fiapx-terraform-state-lgrando"
    key     = "infra-video-worker/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}