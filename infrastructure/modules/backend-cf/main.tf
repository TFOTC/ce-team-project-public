resource "aws_cloudfront_distribution" "ce-tfotc-backend-host" {
  origin {
    domain_name = "tfotc-temp-1824844695.eu-west-2.elb.amazonaws.com"
    custom_origin_config {
      http_port              = 80
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
      https_port             = 443
    }
    origin_id = var.origin_id
  }

  enabled = true

  default_cache_behavior {
    cached_methods         = ["GET", "HEAD"]
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    target_origin_id       = var.origin_id
    viewer_protocol_policy = "allow-all"
    compress               = true

    forwarded_values {
      headers = ["*"]
      cookies {
        forward = "none"
      }
      query_string = false
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["GB"]
    }
  }

  tags = {
    Name      = "ce-tfotc-backend-host"
    ManagedBy = "Terraform"
    OwnedBy   = "The Fellowship of the Cloud"
    Project   = "CE-TEAM-PROJECT"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
