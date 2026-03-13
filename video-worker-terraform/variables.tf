variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "cluster_name" {
  type = string
  default = "fiap-hackathon-eks"
}

variable "app_name" {
  type    = string
  default = "fiapx-hackathon-video-worker"
}

variable "docker_image" {
  type = string
}

variable "replicas" {
  type    = number
  default = 2
}

variable "environment" {
  type    = string
  default = "Development"
}

variable "bucket_access_key_id" {
  description = "Usuario acesso bucket"
  type        = string
  sensitive   = true
}

variable "bucket_secret_key" {
  description = "Senha acesso bucket"
  type        = string
  sensitive   = true
}