
# ============ Config cluster eks ============

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.8"

  cluster_name    = var.cluster_name
  cluster_version = "1.32"

  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true

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

  access_entries = {
    github_actions = {
      kubernetes_group = ["system:masters"]
      principal_arn     = "arn:aws:iam::857378965163:role/github-actions"

      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            namespaces = []
            type       = "cluster"
          }
        }
      }
    }
    devops = {
      kubernetes_group = ["system:masters"]
      principal_arn     = "arn:aws:iam::857378965163:user/giovane"

      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            namespaces = []
            type       = "cluster"
          }
        }
      }
    }    
  }

  tags = merge(tomap({
            Name = "k8s-cluster-urbanfood"}),
            local.common_tags,
         )
  
}
