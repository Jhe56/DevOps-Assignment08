#!/bin/bash
set -e

sudo dnf install -y docker
sudo systemctl start docker
sudo systemctl enable docker
sudo systemctl status docker

sudo dnf install -y ansible-core
sudo ansible --version

mkdir -p /home/ec2-user/.ssh
cat /tmp/key.pub >> /home/ec2-user/.ssh/authorized_keys
chown -R ec2-user:ec2-user /home/ec2-user/.ssh
chmod 700 /home/ec2-user/.ssh
chmod 600 /home/ec2-user/.ssh/authorized_keys