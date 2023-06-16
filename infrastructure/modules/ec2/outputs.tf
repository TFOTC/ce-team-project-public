output "ec2_id"{
    description = "The ID of the EC2 Instance"
    value = module.aws_instance.terraform_instance
}

output "security_group_id"{
    description = "The ID of the security group"
    value = module.aws_security_group.security_group_id
}