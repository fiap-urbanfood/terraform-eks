
# ============ Config cluster eks ============

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.8"

  cluster_name    = var.cluster_name
  cluster_version = "1.32"

  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = false

  cluster_addons = {
    aws-ebs-csi-driver = {
      service_account_role_arn = module.irsa-ebs-csi.iam_role_arn
      most_recent = true
    }
    coredns                = { most_recent = true }
    kube-proxy             = { most_recent = true }
    vpc-cni                = { most_recent = true }
    eks-pod-identity-agent = { most_recent = true }
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"
  }

  eks_managed_node_groups = {
    default = {
      name = "node-group-1"

      instance_types = ["m6i.large", "t3.medium"]

      min_size     = 1
      max_size     = 3
      desired_size = 2
    }
  }

  tags = merge(tomap({
            Name = "k8s-cluster-urbanfood"}),
            local.common_tags,
         )
  
}

# ============ Config Acessos ao eks ============

variable "iam_access_entries" {
  type = list(object({
    policy_arn     = string
    principal_arn  = string
  }))

  default = [
    {
      policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
      principal_arn = "arn:aws:iam::857378965163:user/terraform-iac"
    },
    {
      policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
      principal_arn = "arn:aws:iam::857378965163:user/giovane"
    },
    {
      policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
      principal_arn = "arn:aws:iam::857378965163:role/github-actions"
    },
  ]
}

resource "aws_eks_access_entry" "eks_access_entry" {
  for_each      = { for entry in var.iam_access_entries : entry.principal_arn => entry }
  cluster_name  = module.eks.cluster_name
  principal_arn = each.value.principal_arn
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "eks_policy_association" {
  for_each      = { for entry in var.iam_access_entries : entry.principal_arn => entry }
  cluster_name  = module.eks.cluster_name
  policy_arn    = each.value.policy_arn
  principal_arn = each.value.principal_arn

  access_scope {
    type = "cluster"
  }
}