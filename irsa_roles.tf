module "vpc_cni_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name_prefix      = "VPC-CNI-IRSA"
  attach_vpc_cni_policy = true
  vpc_cni_enable_ipv4   = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-node"]
    }
  }

  tags = local.tags
}

module "s3_iam_policy" {
  source = "terraform-aws-modules/iam/aws//modules/iam-policy"

  name        = "s3-eks"
  path        = "/"
  description = "S3 policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:*",
        ]
        // obviously not the best practice, only for omitting the code for S3 bucket creation
        Resource = "*"
      }
    ]
  })

}

module "s3_iam_eks_role" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  role_name = "my-app-eks-s3"

  role_policy_arns = {
    policy = module.s3_iam_policy.arn
  }

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["default:my-app"]
    }
  }
}