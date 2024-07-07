# Outputs
output "region" {
  value = var.region
}

output "project_name" {
  value = var.project_name
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet" {
  value = module.vpc.public_subnet
}

output "private_subnet" {
  value = module.vpc.private_subnet
}

output "igw_id" {
  value = module.vpc.igw_id
}


output "db_sg_id" {
  value = module.security_groups.db_sg_id
}

output "db_endpoint" {
  value = module.rds.db_endpoint
}

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



