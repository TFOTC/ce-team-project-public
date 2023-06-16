resource "aws_instance" "terraform_instance" {
  ami           = "ami-0eb260c4d5475b901"   # Replace with the desired AMI ID
  instance_type = "t2.micro"       # Replace with the desired instance type
  key_name = "product"
  vpc_security_group_ids = ["sg-0be12b0b11c5329c5"]
  subnet_id = "subnet-0c45a5f3e8318cbc0"    # Replace with the actual subnet ID
  iam_instance_profile = "ec2-instance-profile"
  associate_public_ip_address=true
#   user_data = data.template_file.user_data.rendered
  user_data = templatefile("./user_data.tpl",{html_content = file("./website_files/index.html"), msg = "Hello World"})

  tags = {
    Name = "terraform-instance"
  }

  depends_on = [ aws_security_group.terraform_security_group,aws_vp ]
}

output "aws_instance_public_dns" {
  value = aws_instance.terraform_instance.public_dns
}


resource "aws_ami_from_instance" "terraform_ec2_ami" {
  name                = "terraform-ec2-ami"
  source_instance_id  = aws_instance.terraform_instance.id
  #wait_for_completion = true
}



resource "aws_lb" "terraform_lb" {
  name               = "terraform-lb"
  load_balancer_type = "application"
  subnets            = ["subnet-1", "subnet-2","subnet-3"]

  security_groups = [aws_security_group.terraform_security_group.id]

  tags = {
    Name = "terraform-lb"
  }

  depends_on = [ aws_security_group.terraform_security_group ]
}

resource "aws_lb_target_group" "example_target_group" {
  name        = "example-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = "VPC ID"
  target_type = "instance"
}

resource "aws_lb_listener" "example_listener" {
  load_balancer_arn = aws_lb.terraform_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.example_target_group.arn
  }
}


resource "aws_lb_target_group_attachment" "example_attachment" {
  target_group_arn = aws_lb_target_group.example_target_group.arn
  target_id        = aws_instance.terraform_instance.id
  port             = 80
}