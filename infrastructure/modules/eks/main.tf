module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.15.2"

  cluster_name    = var.cluster_name
  cluster_version = "1.27"

  cluster_endpoint_public_access = true

  vpc_id                   = var.vpc_id
  subnet_ids               = var.private_subnet_ids
  control_plane_subnet_ids = var.private_subnet_ids

  eks_managed_node_groups = {
    one = {
      name           = "tfotc-nodegroup-1"
      instance_types = ["t3.micro"]

      min_size     = 1
      max_size     = 3
      desired_size = 2
    }
  }

  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::529351201608:user/Fabio"
      username = "Fabio"
    },
    {
      userarn  = "arn:aws:iam::529351201608:user/Keven"
      username = "Keven"
    }
  ]

  tags = {
    Name      = var.cluster_name
    ManagedBy = "Terraform"
    OwnedBy   = "The Fellowship of the Cloud"
    Project   = "CE-TEAM-PROJECT"
  }

}

resource "aws_eks_addon" "coredns" {
  cluster_name  = module.eks.cluster_name
  addon_name    = "coredns"
  addon_version = "v1.10.1-eksbuild.1"
}
