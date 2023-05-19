

output "cluster_name" {
  description = "Name of EKS cluster in AWS."
  value       = module.eks.cluster_name
}

output "region" {
  description = "AWS region"
  value       = var.region
}
