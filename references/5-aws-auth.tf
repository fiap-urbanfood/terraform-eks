
# ============ Autorizar o github-actions a fazer deploy no EKS ============

module "eks-aws-auth" {
  source  = "terraform-aws-modules/eks/aws//modules/aws-auth"
  version = "~> 20.0"

  manage_aws_auth_configmap = true
  create_aws_auth_configmap = false

  aws_auth_roles = [
    {
      rolearn  = "arn:aws:iam::857378965163:role/github-actions"
      username = "github-actions"
      groups   = ["system:masters", "system:nodes"]
    },
  ]

  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::857378965163:user/terraform-iac"
      username = "terraform-iac"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::857378965163:user/github-actions"
      username = "github-actions"
      groups   = ["system:masters"]
    }
  ]

  aws_auth_accounts = [
    "857378965163"
  ]
}
