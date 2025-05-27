locals {
  account_id  = "857378965163"
  vpc_cidr = "10.82.0.0/20"
  # Tags comuns para todos os recursos
  common_tags = {
    project = "urbanfood"
    deploy  = "terraform-eks"
    github  = "github.com/fiap-urbanfood"
  }
}

variable "aws_region" {
  description = "região utilizada"
  type        = string
  default     = "us-east-1"
}

variable "vpc_name" {
  description = "Nome da VPC"
  type        = string
  default     = "vpc-urbanfood"
}

variable "cluster_name" {
  description = "Nome do cluster EKS"
  type        = string
  default     = "k8s-urbanfood"
}

variable "ecr_name" {
  description = "ECR NAME"
  type        = list(string)
  default     = ["urbanfood/cliente", "urbanfood/login", "urbanfood/pedidos", "urbanfood/produtos", "urbanfood/nginx"]
}

variable "image_mutability" {
  description = "Fornecer mutabilidade de imagem"
  type        = string
  default     = "MUTABLE"
}

variable "encrypt_type" {
  description = "Tipo de criptografia utilizada na imagem"
  type        = string
  default     = "KMS"
}
