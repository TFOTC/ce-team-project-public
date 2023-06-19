# Remote State

> NOTE: The purpose of this directory is solely to create the storage for the remote state that the infrastructure will be using. Unless you need to re-create the entire infrastructure from scratch, please DO NOT change these files, or perform any terraform commands. If you do need to re-create from scratch, please find the instructions for how to set up the remote state storage here:

1. Run:  `terraform destroy`
2. Run: `terraform init`
    - 2.5. If you would like to change the name of the storage, you can do so by changing the value of *remote_name* in the **main.tf** file.
3. Run: `terraform apply`