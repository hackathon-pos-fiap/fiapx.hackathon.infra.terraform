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
  default = "fiapx-hackathon-video-manager-api"
}

variable "docker_image" {
  type = string
}

variable "replicas" {
  type    = number
  default = 1
}

variable "container_port" {
  type    = number
  default = 8080
}

variable "environment" {
  type    = string
  default = "Development"
}

variable "fiapx_user_password" {
  description = "Senha do usuário do MongoDB Atlas"
  type        = string
  sensitive   = true
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