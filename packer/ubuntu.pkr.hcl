packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = ">= 1.3.0"
    }
  }
}

variable "name" {
  type = string
}

variable "project_name" {
  type = string
}

variable "public_key_path" {
  type = string
}

source "amazon-ebs" "ami" {
  region        = "us-east-1"
  instance_type = "t2.micro"
  ssh_username  = "ubuntu"

  ami_name = "devops-ami-{{timestamp}}"

  tags = {
    Name      = var.name
    Project   = var.project_name
    CreatedBy = "packer-jhe56"
  }

  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    owners      = ["amazon"]
    most_recent = true
  }
}

build {
  sources = ["source.amazon-ebs.ami"]

  provisioner "file" {
    source      = var.public_key_path
    destination = "/tmp/key.pub"
  }

  provisioner "shell" {
    script = "ubuntu-setup.sh"
  }
}
