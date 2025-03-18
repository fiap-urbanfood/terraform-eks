
# ============ Public Security Group ============

resource "aws_security_group" "public_eks" {
  name = "SecGroup Public Cluster EKS"
  description = "eks internet access"

  vpc_id="${aws_vpc.eks-vpc.id}"

  tags = merge(tomap({
            Name = "sg-public-eks"}),
            local.common_tags,
         )
}

resource "aws_security_group_rule" "eks_out" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
 
  security_group_id = aws_security_group.public_eks.id
}

resource "aws_security_group_rule" "public_eks_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public_eks.id
}
 
resource "aws_security_group_rule" "public_in_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public_eks.id
}

# ============ Private Security Group ============
 
resource "aws_security_group" "private_eks" {
  name = "SecGroup Private Cluster EKS"  
  description = "Private internet access"
  vpc_id="${aws_vpc.eks-vpc.id}"
 
  tags = merge(tomap({
            Name = "sg-private-eks"}),
            local.common_tags,
         )  
}
 
resource "aws_security_group_rule" "private_out" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
 
  security_group_id = aws_security_group.private_eks.id
}
 
resource "aws_security_group_rule" "private_in" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks = [aws_vpc.eks-vpc.cidr_block]
 
  security_group_id = aws_security_group.private_eks.id
}