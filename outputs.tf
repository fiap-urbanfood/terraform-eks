# ============ Output vpc-id ============

output "region" {
  description = "AWS region"
  value       = var.aws_region
}

output "vpc_id" {
  description = "ID VPC"
  value       = module.vpc.vpc_id
}

# ============ Output Subnet ============

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

# ============ Output NAT gateways ==========

output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = module.vpc.nat_public_ips
}

# ============ Output EKS Config ============

output "cluster_name" {
  description = "Kubernetes EKS Cluster Name"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "cluster_status" {
  description = "Status do cluster EKS. Exemplo: `CREATING`, `ACTIVE`, `DELETING`, `FAILED`"
  value       = module.eks.cluster_status
}

output "cluster_service_cidr" {
  description = "O bloco CIDR onde os endereços IP do pod e do serviço do Kubernetes são atribuídos"
  value       = module.eks.cluster_service_cidr
}

output "cluster_ip_family" {
  description = "A família de IP usada pelo cluster (por exemplo, `ipv4` ou `ipv6`)"
  value       = module.eks.cluster_ip_family
}

# ============ Node Security Group ============

output "node_security_group_arn" {
  description = "Amazon Resource Name (ARN) do grupo de segurança do node compartilhado"
  value       = module.eks.node_security_group_arn
}

output "node_security_group_id" {
  description = "ID do Security group do node compartilhado"
  value       = module.eks.node_security_group_id
}

# ============ Output SecurityGroup ============

output "cluster_security_group_id" {
  description = "Security group id anexado ao control plane"
  value       = module.eks.cluster_security_group_id
}

output "cluster_primary_security_group_id" {
  description = "Security Group de cluster que foi criado pelo Amazon EKS para o cluster."
  value       = module.eks.cluster_primary_security_group_id
}

# ============ Output ECR ============

#output "registry_id" {
#  description = "O ID da conta do registro que contém o repositório."
#  value = aws_ecr_repository.ecr[each.key].registry_id
#}

#output "repository_url" {
#  description = "URL do repositório."
#  value = aws_ecr_repository.ecr[each.key].repository_url
#}