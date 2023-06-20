output "cloudfront_dns" {
  description = "The dns of cloudfront"
  value       = aws_cloudfront_distribution.ce-tfotc-backend-host.domain_name
}
