output "ec2_id_one" {
  description = "The ID of the EC2 Instance"
  value       = aws_instance.terraform_instance_one.id
}

output "ec2_id_two" {
  description = "The ID of the EC2 Instance"
  value       = aws_instance.terraform_instance_two.id
}

output "security_group_id" {
  description = "The ID of the security group"
  value       = aws_security_group.terraform_security_group.id
}

output "aws_instance_public_one_dns" {
  value = aws_instance.terraform_instance_one.public_dns
}

output "aws_instance_public_two_dns" {
  value = aws_instance.terraform_instance_two.public_dns
}
