output "bucket_dns" {
  description = "The dns of the s3 bucket"
  value       = aws_s3_bucket.ce-tfotc-frontend-host.bucket_regional_domain_name
}

output "cloudfront_dns" {
  description = "The dns of cloudfront"
  value       = aws_cloudfront_distribution.ce-tfotc-frontend-host.domain_name
}
