
# ============ IAM role for eks ============

# aws-ebs-csi-driver O driver EBS CSI fornece uma interface CSI usada por orquestradores de contêineres para gerenciar o ciclo de vida dos volumes do Amazon EBS.
# A disponibilidade em complementos EKS na visualização permite uma experiência simples para anexar armazenamento persistente a um cluster EKS.
# https://registry.terraform.io/modules/bootlabstech/fully-loaded-eks-cluster/aws/latest/submodules/aws-ebs-csi-driver

# module.eks.aws_iam_role.this[0]

data "aws_iam_policy" "ebs_csi_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

module "irsa-ebs-csi" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "5.39.0"

  create_role                   = true
  role_name                     = "AmazonEKSTFEBSCSIRole-${module.eks.cluster_name}"
  provider_url                  = module.eks.oidc_provider
  role_policy_arns              = [data.aws_iam_policy.ebs_csi_policy.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
}

resource "aws_iam_role" "k8s_urbanfood" {
  name = var.cluster_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })

  tags = merge(tomap({
           Name = "role-eks-urbanfood"}),
           local.common_tags,
  ) 

}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.k8s_urbanfood.name
}