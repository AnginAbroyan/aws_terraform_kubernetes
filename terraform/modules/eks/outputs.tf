output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_id" {
  value = module.eks.cluster_id
}


output "cluster_endpoint" {
  description = "The endpoint for your EKS Kubernetes API server."
  value       = module.eks.cluster_endpoint
}


output "cluster_certificate_authority_data" {
  description = "The EKS cluster certificate authority data."
  value       = module.eks.cluster_certificate_authority_data
}

