output "ecr_backend_url" {
  description = "The repository URL"
  value       = aws_ecr_repository.ce-tfotc-ecr-backend.repository_url
}
