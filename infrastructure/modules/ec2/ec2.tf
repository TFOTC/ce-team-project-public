resource "aws_instance" "terraform_instance" {
  ami           = "ami-0eb260c4d5475b901"   # Replace with the desired AMI ID
  instance_type = "t2.micro"       # Replace with the desired instance type
  #key_name = "product"
  vpc_security_group_ids = [aws_security_group.terraform_security_group.id]
  subnet_id = var.private_subnet    # Replace with the actual subnet ID
  
  associate_public_ip_address=true

  user_data = templatefile("./user_data.tpl")

  tags = {
    Name = "terraform-instance"
  }

  depends_on = [ aws_security_group.terraform_security_group,aws_vp ]
}

output "aws_instance_public_dns" {
  value = aws_instance.terraform_instance.public_dns
}


