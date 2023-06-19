
output "rds_endpoint" {
  description = "RDS endpoint to use for connection string"
  value       = aws_db_instance.project_db.endpoint
}
