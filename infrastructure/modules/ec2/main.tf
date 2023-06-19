resource "aws_instance" "terraform_instance_one" {

  ami                    = "ami-0eb260c4d5475b901"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.terraform_security_group.id]
  subnet_id              = var.public_subnet_one

  key_name = aws_key_pair.ce-tfotc-key-pair.id

  associate_public_ip_address = true

  user_data = filebase64("${path.module}/user_data.tpl")

  tags = {
    Name      = "tfotc-terraform-instance-one"
    UsedBy    = "The Fellowship of the Cloud"
    ManagedBy = "Terraform"
  }

  depends_on = [aws_security_group.terraform_security_group]
}

resource "aws_instance" "terraform_instance_two" {

  ami                    = "ami-0eb260c4d5475b901"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.terraform_security_group.id]
  subnet_id              = var.public_subnet_two

  key_name = aws_key_pair.ce-tfotc-key-pair.id

  associate_public_ip_address = true

  user_data = filebase64("${path.module}/user_data.tpl")

  tags = {
    Name      = "tfotc-terraform-instance-two"
    UsedBy    = "The Fellowship of the Cloud"
    ManagedBy = "Terraform"
  }

  depends_on = [aws_security_group.terraform_security_group]
}

resource "aws_key_pair" "ce-tfotc-key-pair" {
  key_name   = "ce-tfotc-key-pair"
  public_key = file("~/.ssh/id_rsa.pub")
  tags = {
    Name      = "ce-tfotc-key-pair"
    UsedBy    = "The Fellowship of the Cloud"
    ManagedBy = "Terraform"
  }
}

resource "aws_security_group" "terraform_security_group" {
  name        = "terraform-security-group"
  description = "Terraform security group"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "API server inbound IPv4"
  }

  ingress {
    from_port        = 3000
    to_port          = 3000
    protocol         = "tcp"
    ipv6_cidr_blocks = ["::/0"]
    description      = "API server inbound IPv6"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "API server inbound IPv4"
  }

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    ipv6_cidr_blocks = ["::/0"]
    description      = "API server inbound IPv6"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH access from my computer"
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

