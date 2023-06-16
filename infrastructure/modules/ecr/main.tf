resource "aws_ecr_repository" "ce-tfotc-ecr-backend" {
  name                 = var.ecr_backend_name
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name      = var.ecr_backend_name
    ManagedBy = "Terraform"
    OwnedBy   = "The Fellowship of the Cloud"
    Project   = "CE-TEAM-PROJECT"
  }
}
