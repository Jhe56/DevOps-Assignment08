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

Make sure you save the output information.

## Ansible
To ssh into the ansible controller instance you must temporarily "forward" your "local ssh agent" telling it, "USE THIS KEY":

**ssh-add ~/.ssh/[your ssh name (same as what you created at the beginning)]**
**ssh-add -l**

Now you can ssh into your bastion using the following:

**ssh -A -i ~/.ssh/assignment08-key.pem ec2-user@<Ans_Controller_IP>**

[cd] into ansible_quickstart and create the following files:
### inventory.ini
```
[myhosts]
#aws instances
[aws-ip-1]       ansible_user=ec2-user
[aws-ip-2]       ansible_user=ec2-user
[aws-ip3]        ansible_user=ec2-user
#ubuntu instances
[ubuntu-ip-1]    ansible_user=ubuntu
[ubuntu-ip-2]    ansible_user=ubuntu
[ubuntu-ip-3]    ansible_user=ubuntu
```
Now you can run the commands:
* ansible-inventory -i inventory.ini --list
* ansible myhosts -m ping -i inventory.ini

**Note: the ping command may seem to hang: just type yes, this is due to one of a couple of the instances responding faster than the prompt [yes/no]**

You could also just ssh into each instance first if you prefer.

### playbook.yaml
```
#name of our play
- name: My play
  #references our inventory.ini host list (name/category: myhosts)
  hosts: myhosts
  #function in names
  tasks:
   - name: Ping my hosts
     ansible.builtin.ping:

   - name: Print message
     ansible.builtin.debug:
       msg: Running!
       
   #registers instance's current docker version
   - name: Register Docker Version
     ansible.builtin.shell: docker --version
     register: instance_docker_version

   #checks if docker needs an update (will just run sudo apt update)
   - name: Check/Update Ubuntu Docker
     ansible.builtin.shell: sudo apt update
     when:
       - ansible_user=="ubuntu"
       #current latest version hardcoded rather than curled and registered (feel free to change)
       - instance_docker_version.stdout.find('29.4.0') < 1 

   - name: Check/Update AWSL Docker Version
     ansible.builtin.shell: sudo apt update docker -y
     when:
       - ansible_user=="ec2-user"
       - instance_docker_version.stdout.find('25.0.14') < 1

   - name: Register Disk Usage
     ansible.builtin.shell: df -h
     register: disk_info

   #displays the disk usage of each ec2 instance
   - name: Displaying Disk Usage
     ansible.builtin.debug:
       var: disk_info.stdout
```
<sub>Not very friendly if working with a specific docker version but otherwise compliant</sub>

Run: ansible-playbook -i inventory.ini playbook.yaml
