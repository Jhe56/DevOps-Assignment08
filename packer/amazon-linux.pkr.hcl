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
  ssh_username  = "ec2-user"

  ami_name = "devops-ami-{{timestamp}}"

  tags = {
    Name      = var.name
    Project   = var.project_name
    CreatedBy = "packer-jhe56"
  }

  source_ami_filter {
    filters = {
      name                = "al2023-ami-*-x86_64"
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
    inline = [
      "sudo dnf install -y docker",
      "sudo systemctl start docker",
      "sudo systemctl enable docker",
      "sudo systemctl status docker",
      "mkdir -p /home/ec2-user/.ssh",
      "cat /tmp/key.pub >> /home/ec2-user/.ssh/authorized_keys",
      "chown -R ec2-user:ec2-user /home/ec2-user/.ssh",
      "chmod 700 /home/ec2-user/.ssh",
      "chmod 600 /home/ec2-user/.ssh/authorized_keys"
    ]
  }
}
