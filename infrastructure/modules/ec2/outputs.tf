output "ec2_id" {
  description = "The ID of the EC2 Instance"
  value       = aws_instance.terraform_instance.id
}

output "security_group_id" {
  description = "The ID of the security group"
  value       = aws_security_group.terraform_security_group.id
}
