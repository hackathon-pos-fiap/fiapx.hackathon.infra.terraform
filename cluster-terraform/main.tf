# VPC
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${var.cluster_name}-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["${var.aws_region}a", "${var.aws_region}b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

# Cluster EKS principal
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.30"

  subnet_ids = module.vpc.private_subnets
  vpc_id     = module.vpc.vpc_id

  eks_managed_node_groups = {
    default = {
      desired_size   = var.desired_capacity
      max_size       = 4
      min_size       = 1
      instance_types = [var.instance_type]
      disk_size      = 20
    }
  }

  cluster_endpoint_public_access        = var.cluster_endpoint_public_access
  cluster_endpoint_private_access       = true
  cluster_endpoint_public_access_cidrs  = var.cluster_allowed_cidrs

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
