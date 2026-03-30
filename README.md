# Assignment08: Packer and Terraform
Note: In this repo is a packer and terraform directory. After going through the packer steps, in /terraform/variables.tf and terraform.tfvars change any [YOUR PUBLIC IP] and/or [YOUR AMI ID] to the expected values before proceeding with the terraform instructions

## Getting Started
* Ubuntu/WSL users must install HashiCorp's latest version of Packer and Terraform
* User should also have an ssh key and a key-pair created in their ~/.ssh directory
* Users should also have run [aws configure] and input their aws academy credentials

## Packer
In the packer directory run the following commands:
* packer init amazon-linux.pkr.hcl
* packer build -var "public_key_path=/YOUR PUBLIC KEY PATH/.ssh/id_rsa.pub" amazon-linux.pkr.hcl
