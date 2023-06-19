resource "aws_s3_bucket" "ce-tfotc-frontend-host" {
  bucket = var.bucket_name

  force_destroy = true

  tags = {
    Name      = "ce-tfotc-frontend-host"
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
      "Sid": "ce-tfotc-frontend-host",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::ce-tfotc-frontend-host/*",
      "Principal": "*"
    }
  ]
}
  POLICY
}

resource "aws_iam_policy" "github-pipeline" {
  name = "github-pipeline"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
			"Sid": "AccessToGetBucketLocation",
			"Effect": "Allow",
			"Action": [
			    "s3:GetBucketLocation"
			    ],
			"Resource": [
			    "arn:aws:s3:::*"
			    ]
		},
		{
			"Sid": "AccessToWebsiteBuckets",
			"Effect": "Allow",
			"Action": [
			    "s3:PutBucketWebsite",
			    "s3:PutObject",
			    "s3:PutObjectAcl",
			    "s3:GetObject",
			    "s3:ListBucket",
			    "s3:DeleteObject"
			    ],
			"Resource": [
			    "arn:aws:s3:::ce-tfotc-frontend-host",
			    "arn:aws:s3:::ce-tfotc-frontend-host/*"
			    ]
		},
    {
      "Sid": "AssumeIAMRole",
      "Effect": "Allow",
      "Action": "iam:PassRole",
      "Resource": "arn:aws:iam::529351201608:role/AWSReservedSSO_AWSAdministratorAccess_08deacc2663a7d72"
    }

  ]
}
  POLICY
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

    viewer_protocol_policy = "redirect-to-https"
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

  custom_error_response {
    error_code         = 404
    response_code      = 200
    response_page_path = "/index.html"
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["GB"]
    }
  }

  tags = {
    Name      = "ce-tfotc-frontend-host"
    ManagedBy = "Terraform"
    OwnedBy   = "The Fellowship of the Cloud"
    Project   = "CE-TEAM-PROJECT"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
