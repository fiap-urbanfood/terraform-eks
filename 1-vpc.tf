# ============ config vpc ============

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.1"

  name = var.vpc_name

  cidr = local.vpc_cidr

  azs  = ["us-east-1a", "us-east-1b"]
  public_subnets  = ["10.82.2.0/24", "10.82.4.0/24"]
  private_subnets = ["10.82.5.0/24", "10.82.7.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  # Acesso público às instâncias do RDS
  create_database_subnet_group           = true
  create_database_subnet_route_table     = true
  create_database_internet_gateway_route = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

  tags = merge(tomap({
          Name = "k8s-vpc"}),
          local.common_tags,
        )

}
