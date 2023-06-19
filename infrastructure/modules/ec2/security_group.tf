resource "aws_security_group" "terraform_security_group" {
  name        = "terraform-security-group"
  description = "Terraform security group"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "API server inbound IPv4"
  }

  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    ipv6_cidr_blocks = ["::/0"]
    description     = "API server inbound IPv6"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "API server inbound IPv4"
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    ipv6_cidr_blocks = ["::/0"]
    description     = "API server inbound IPv6"
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