output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_id" {
  value = module.eks.cluster_id
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  value = module.vpc.vpc_cidr_block
}

output "cluster_certificate_authority_data" {
  value = module.eks.cluster_certificate_authority_data
}

output "node_role_arn" {
  value = module.eks.eks_managed_node_groups["default"].iam_role_arn
}

# Security Group padrão do cluster EKS
output "eks_security_group_id" {
  description = "Security Group associado ao EKS Cluster (para uso no VPC Link)."
  value       = module.eks.cluster_security_group_id
}