resource "aws_efs_file_system" "data" {

  creation_token = "${module.eks.cluster_name}-data"
  tags = {
    Name = "${module.eks.cluster_name}-data"
  }
}

resource "aws_efs_mount_target" "data" {
  count           = length(module.vpc.private_subnets)
  file_system_id  = aws_efs_file_system.data.id
  subnet_id       = module.vpc.private_subnets[count.index]
  security_groups = [aws_security_group.allow-efs.id]
}

resource "aws_security_group" "allow-efs" {
  name        = "${local.cluster_name}-allow-efs-sg"
  description = "Allow EFS access for EKS cluster."
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = module.vpc.private_subnets_cidr_blocks
  }

  tags = {
    Name = "Allow EFS access for ${local.cluster_name}"
  }
}

module "efs_csi_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.19.0"

  role_name_prefix      = "${var.prefix}-efs-csi"
  attach_efs_csi_policy = true

  oidc_providers = {
    one = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:efs-csi-controller-sa"]
    }
  }
}
