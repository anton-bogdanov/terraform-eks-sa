output "cluster_name" {
  value = local.cluster_name
}

output "region" {
  value = local.region
}

output "eks_s3_role_arn" {
  value = module.s3_iam_eks_role.iam_role_arn
}