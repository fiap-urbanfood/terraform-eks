# ============ Output vpc-id ============

output "vpc_id" {
  value = aws_vpc.eks-vpc.id
}

# ============ Output Subnet ============

output "public_subnet_1a" {
  value = aws_subnet.public-subnet-1a.id
}

output "public_subnet_1b" {
  value = aws_subnet.public-subnet-1b.id
}

# ============ Output EKS Config ============

# ============ Output SecurityGroup ============

output "security_group_public" {
  value = aws_security_group.public_eks.id
}
 
output "security_group_private" {
  value = aws_security_group.private_eks.id
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