resource "aws_ecr_repository" "app" {
  name                 = "${var.prefix}-app"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "proxy" {
  name                 = "${var.prefix}-proxy"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_iam_policy" "allow_ecr_app" {
  name = "${local.cluster_name}-read-ecr-app"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetAuthorizationToken"
        ],
        Resource = aws_ecr_repository.app.arn
      }
    ]
  })
}

resource "aws_iam_policy" "allow_ecr_proxy" {
  name = "${local.cluster_name}-eks-read-ecr-proxy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetAuthorizationToken"
        ],
        Resource = aws_ecr_repository.proxy.arn
      }
    ]
  })
}
