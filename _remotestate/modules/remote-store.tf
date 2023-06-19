resource "aws_s3_bucket" "ce-tfotc-remote-store-fm" {

  bucket        = var.remote_name
  force_destroy = true

  tags = {
    Name      = var.remote_name
    ManagedBy = "Terraform"

  }
}

resource "aws_s3_bucket_versioning" "ce-tfotc-remote-store-fm" {

  bucket = aws_s3_bucket.ce-tfotc-remote-store-fm.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "ce-tfotc-remote-store-fm" {
  bucket = aws_s3_bucket.ce-tfotc-remote-store-fm.id

}

# resource "aws_s3_bucket_policy" "ce-tfotc-remote-store" {
#   bucket = aws_s3_bucket.ce-tfotc-remote-store.id

#   policy = <<POLICY
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Sid": "ce-tfotc-remote-store-permissions-1",
#       "Effect": "Allow",
#       "Principal": {
#         "AWS": "arn:aws:iam::133711366931:root"        
#       },
#       "Action": [
#         "s3:ListBucket",
#         "s3:GetObject",
#         "s3:PutObject"
#       ],
#       "Resource": [
#         "arn:aws:s3:::ce-tfotc-remote-store/*"
#       ]  
#     },
#     {
#       "Sid": "ce-tfotc-remote-store-permissions-2",
#       "Effect": "Allow",
#       "Principal": {
#         "AWS": "arn:aws:iam::053636544826:root"        
#       },
#       "Action": [
#         "s3:ListBucket",
#         "s3:GetObject",
#         "s3:PutObject"
#       ],
#       "Resource": [
#         "arn:aws:s3:::ce-tfotc-remote-store/*"
#       ]  
#     }
#   ]
# }
# POLICY
# }

resource "aws_dynamodb_table" "ce-tfotc-remote-store-fm" {

  name           = var.remote_name
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    Name      = "DynamoDB Terraform State Lock Table"
    ManagedBy = "Terraform"
    OwnedBy   = "The Fellowship of the Cloud"
    Project   = "CE-TEAM-PROJECT"
  }
}
