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
  value       = module.eks.cluster_security_group_id
}

