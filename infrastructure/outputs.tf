output "rds_endpoint" {
  description = "RDS endpoint to use for connection string"
  value       = module.database.rds_endpoint
}

output "private_subnets" {
  value = module.network.private_subnets
}
