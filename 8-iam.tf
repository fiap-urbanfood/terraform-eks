
data "tls_certificate" "eks" {
  url = aws_eks_cluster.cluster-urbanfood.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.cluster-urbanfood.identity[0].oidc[0].issuer
}

data "aws_iam_user" "devops" {
  user_name = "terraform-iac"
}

resource "aws_eks_access_entry" "devops" {
  cluster_name  = aws_eks_cluster.cluster-urbanfood.name
  principal_arn = data.aws_iam_user.devops.arn
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "devops_AmazonEKSAdminPolicy" {
  cluster_name  = aws_eks_cluster.cluster-urbanfood.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
  principal_arn = aws_eks_access_entry.devops.principal_arn

  access_scope {
    type = "cluster"
  }
}

resource "aws_eks_access_policy_association" "devops_AmazonEKSClusterAdminPolicy" {
  cluster_name  = aws_eks_cluster.cluster-urbanfood.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = aws_eks_access_entry.devops.principal_arn

  access_scope {
    type = "cluster"
  }
}
