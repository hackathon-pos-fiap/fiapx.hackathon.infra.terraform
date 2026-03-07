variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "Nome do cluster EKS"
  type        = string
  default     = "fiap-hackathon-eks"
}

variable "desired_capacity" {
  description = "Quantidade de nós no Node Group"
  type        = number
  default     = 3
}

variable "instance_type" {
  description = "Tipo de instância EC2 para os nodes"
  type        = string
  default     = "c7i-flex.large"
}

variable "cluster_endpoint_public_access" {
  description = "Habilita endpoint público do EKS"
  type        = bool
  default     = true
}

variable "cluster_allowed_cidrs" {
  description = "Lista de CIDRs que podem acessar o endpoint público"
  type        = list(string)
  default     = ["0.0.0.0/0"] 
}
