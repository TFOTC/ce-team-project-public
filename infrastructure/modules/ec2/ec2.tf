resource "aws_instance" "terraform_instance" {
  ami           = "ami-0eb260c4d5475b901" # Replace with the desired AMI ID
  instance_type = "t2.micro"              # Replace with the desired instance type
  #key_name = "product"
  vpc_security_group_ids = [aws_security_group.terraform_security_group.id]
  subnet_id              = var.public_subnet # Replace with the actual subnet ID

  # key_name = aws_key_pair.ce-tfotc-key-pair.id

  associate_public_ip_address = true

  user_data = filebase64("${path.module}/user_data.tpl")

  tags = {
    Name = "tfotc-terraform-instance"
  }

  depends_on = [aws_security_group.terraform_security_group]
}

output "aws_instance_public_dns" {
  value = aws_instance.terraform_instance.public_dns
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


