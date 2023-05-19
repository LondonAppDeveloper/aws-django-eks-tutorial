locals {
  cluster_name = "${var.prefix}-cluster"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.14"

  cluster_name    = local.cluster_name
  cluster_version = "1.26"

  vpc_id                               = module.vpc.vpc_id
  subnet_ids                           = module.vpc.private_subnets
  cluster_endpoint_public_access       = true
  cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"] # Update to your IP

  iam_role_additional_policies = {
    AllowECRApp   = aws_iam_policy.allow_ecr_app.arn
    AllowECRProxy = aws_iam_policy.allow_ecr_proxy.arn
  }

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"
  }

  eks_managed_node_groups = {
    node_group = {
      name = "k8s-ng-1"

      instance_types = ["t3.small"]

      min_size     = 1
      max_size     = 3
      desired_size = 1

      labels = {
        Environment = "Dev"
      }
    }
  }
}

module "vpc_cni_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.19"

  role_name_prefix      = "${var.prefix}-vpc-cni-irsa"
  attach_vpc_cni_policy = true
  vpc_cni_enable_ipv4   = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-node"]
    }
  }
}
