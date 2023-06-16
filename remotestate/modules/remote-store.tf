resource "aws_s3_bucket" "ce-tfotc-remote-store" {

  bucket        = var.remote_name
  force_destroy = true

  tags = {
    Name      = var.remote_name
    ManagedBy = "Terraform"

  }
}

resource "aws_s3_bucket_versioning" "ce-tfotc-remote-store" {

  bucket = aws_s3_bucket.ce-tfotc-remote-store.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "ce-tfotc-remote-store" {

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
