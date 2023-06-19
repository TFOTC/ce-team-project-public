resource "aws_s3_bucket" "ce-tfotc-frontend-host" {
  bucket = var.bucket_name

  force_destroy = true

  tags = {
    #Name      = "ce-tfotc-frontend-host"
    Name      = "ce-tfotc-frontend-host-fm"
    ManagedBy = "Terraform"
    OwnedBy   = "The Fellowship of the Cloud"
    Project   = "CE-TEAM-PROJECT"
  }
}

resource "aws_s3_bucket_public_access_block" "ce-tfotc-frontend-host" {
  bucket = aws_s3_bucket.ce-tfotc-frontend-host.id

}

resource "aws_s3_bucket_ownership_controls" "ce-tfotc-frontend-host" {
  bucket = aws_s3_bucket.ce-tfotc-frontend-host.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "ce-tfotc-frontend-host" {
  depends_on = [aws_s3_bucket_ownership_controls.ce-tfotc-frontend-host]

  bucket = aws_s3_bucket.ce-tfotc-frontend-host.id
  acl    = "public-read"
}

resource "aws_s3_bucket_versioning" "ce-tfotc-frontend-host" {
  bucket = aws_s3_bucket.ce-tfotc-frontend-host.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "ce-tfotc-frontend-host" {
  bucket = aws_s3_bucket.ce-tfotc-frontend-host.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ce-tfotc-frontend-host-fm",
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::ce-tfotc-frontend-host-fm/*",
      "Principal": "*"
    }
  ]
}
  POLICY
}

module "template_files" {
  source = "hashicorp/dir/template"

  base_dir = "${path.module}/media/dist"

}

resource "aws_s3_object" "ce-tfotc-frontend-host" {
  depends_on = [aws_s3_bucket_acl.ce-tfotc-frontend-host]

  for_each     = module.template_files.files
  bucket       = aws_s3_bucket.ce-tfotc-frontend-host.id
  key          = each.key
  source       = each.value.source_path
  etag         = each.value.digests.md5
  acl          = "public-read"
  content_type = each.value.content_type
  content      = each.value.content
}

resource "aws_s3_bucket_website_configuration" "ce-tfotc-frontend-host" {
  bucket = var.bucket_name

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }

  routing_rule {
    condition {
      key_prefix_equals = "docs/"
    }
    redirect {
      replace_key_prefix_with = "documents/"
    }
  }

}

resource "aws_cloudfront_distribution" "ce-tfotc-frontend-host" {
  origin {
    domain_name = aws_s3_bucket.ce-tfotc-frontend-host.bucket_regional_domain_name
    origin_id   = var.origin_id
  }

  enabled             = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  ordered_cache_behavior {
    path_pattern     = "/content/immutable/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = var.origin_id

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  # Cache behavior with precedence 1
  ordered_cache_behavior {
    path_pattern     = "/content/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["GB", "RO"]
    }
  }

  tags = {
    #Name      = "ce-tfotc-frontend-host"
    Name      = "ce-tfotc-frontend-host-fm"
    ManagedBy = "Terraform"
    OwnedBy   = "The Fellowship of the Cloud"
    Project   = "CE-TEAM-PROJECT"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

}
