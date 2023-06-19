resource "aws_db_subnet_group" "project_db" {
  name       = "project_db"
  subnet_ids = var.public_subnets

  tags = {
    Name = "project_db"
  }
}

resource "aws_security_group" "rds" {
  name   = "project_db_rds"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "project_db_rds"
  }
}

resource "aws_db_parameter_group" "project_db" {
  name   = "projectdb"
  family = "postgres14"

  parameter {
    name  = "log_connections"
    value = "1"
  }
}

resource "aws_db_instance" "project_db" {
  identifier             = "project-db"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "14.8"
  username               = "postgres"
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.project_db.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  parameter_group_name   = aws_db_parameter_group.project_db.name
  publicly_accessible    = true
  skip_final_snapshot    = true

  provisioner "local-exec" {
    command = "PGPASSWORD=${var.db_password} psql --host=${aws_db_instance.project_db.address} --port=5432 --username=postgres -c 'CREATE DATABASE project-db'"
  }

  tags = {
    ManagedBy = "Terraform"
    OwnedBy   = "The Fellowship of the Cloud"
    Project   = "CE-TEAM-PROJECT"
  }
}
