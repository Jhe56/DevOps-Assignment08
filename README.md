# Assignment011: Packer - Terraform - Ansible
## Getting Started
* Ubuntu/WSL users must install HashiCorp's latest version of Packer and Terraform
* User should also have an ssh key and a key-pair created in their ~/.ssh directory
* Users should also have run [aws configure] and input their aws academy credentials

## Packer
In the packer directory run the following commands for each .pkr.hcl file:
* packer init *.pkr.hcl
* packer build -var "name=[optional or whitespace]" -var "project_name=[optional or whitespace]" -var "public_key_path=/YOUR PUBLIC KEY PATH/.ssh/[ssh-name].pub" amazon-linux.pkr.hcl

SAVE each ami, you will be prompted to use them later.

## Terraform
In the terraform directory run:
* terraform init
* terraform plan -out=tfplan <sub>Note:using plan is just easier</sub>
  * You will be prompted for (in this order) Ansible Ami ID, AWSL AMI ID, Ubuntu AMI ID, Key-Pair Name, Your IP, Project Name
* terraform apply tfplan (or terraform apply -auto-approve tfplan)

## Ansible
To ssh into the ansible controller instance you must temporarily "forward" your "local ssh agent" telling it, "USE THIS KEY":

**ssh-add ~/.ssh/[your ssh name (same as what you created at the beginning)]**
**ssh-add -l**

Now you can ssh into your bastion using the following:

**ssh -A -i ~/.ssh/assignment08-key.pem ec2-user@<BASTION_PUBLIC_IP>**

And then ssh into your ec2 instance with:
**ssh ec2-user@<Private_IP>**

For further confirmation you can check if docker is available by running **docker version** 

To exit out of the ec2 instance and return to the bastion you can just hit Ctrl+D and again if you wish to exit out of the bastion.
