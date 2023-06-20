output "rds_endpoint" {
  description = "RDS endpoint to use for connection string"
  value       = module.database.rds_endpoint
}

output "private_subnets" {
  value = module.network.private_subnets
}

output "region" {
  description = "AWS region"
  value       = "eu-west-2"
}

output "cluster_name" {
  description = "Name of the K8s cluster"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "K8s Control Plane endpoint"
  value       = module.eks.cluster_endpoint
}

output "cluster_sg_ids" {
  description = "Control Plane security group ids"
  value       = module.eks.cluster_sg_ids
}
