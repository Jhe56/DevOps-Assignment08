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

Running that last command should start the AMI build process and start with:
<img width="881" height="59" alt="image" src="https://github.com/user-attachments/assets/3d47ac84-1cf2-45ea-b481-9e0baf02e6c0" />

Ending with:
<img width="603" height="48" alt="image" src="https://github.com/user-attachments/assets/5593969b-75cc-4cd6-8df5-a35b9ee5f381" />

Don't be alarmed by anything else. If an error comes up, make sure you've run aws configure and pasted in your credentials correctly, no preceeding or trailing new lines!

During the process you'll see a "transaction summary" of the the following installations being packaged:
<img width="1928" height="861" alt="image" src="https://github.com/user-attachments/assets/c1673a1b-fea8-47e3-8c5c-1e7d9415afba" />

To tell our EC2 instances: "THIS should be here" 
They can also be viewed in our .hcl file, ln 40, in build{...}

## Terraform
