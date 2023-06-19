# Terraform Project - Pre-Init Branch

This branch contains the infrastructure code for provisioning the project's infrastructure. It does not include the state related code, allowing anyone to download and run it locally to provision their own replica of the infrastructure. You will have to create your own providers.tf file to connect to AWS.

## Getting Started

1. Clone the repository to your local machine.

2. Checkout a new branch using `git checkout -b <my-branch-name>`

3. Create a `provider.tf` file with the relevant credentials.

4. Add your changes to the infrastructure code. This should be done by adding modules into the `modules` directory and referencing these modules in `infrastructure/main.tf`.

5. Run `terraform init` followed by `terraform apply` to provision and test your infrastructure.

## Applying Infrastructure Changes

1. Ensure you are on your new branch using `git checkout <my-branch-name>`

2. Run the command `git merge terraform-pre-init` and resolve any merge conflicts.

3. Push to your changes to your branch using `git push origin <my-branch-name>`

4. Switch to the `terraform-pre-init` branch using `git checkout terraform-pre-init`

5. Merge with main using `git merge main` and resolve any conflicts.

6. Push your changes to `terraform-pre-init` using `git push origin terraform-pre-init`.

7. Now switch to the main branch using `git checkout main`.

8. Merge `terraform-pre-init` with `main` using `git merge terraform-pre-init` and resolve any conflicts.

9. Push the updated main branch using `git push origin main`.
