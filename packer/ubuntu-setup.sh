#!/bin/bash
set -e

#Assignment 10, implementing tutorial

#step 1: added -y because otherwise update seems to fail
sudo apt update -y
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce
sudo systemctl status docker

#this line is using sudo for the authority to call the system daemon? system service? to start docker
sudo systemctl start docker
#this is part of setting up docker
sudo systemctl enable docker

#changed the default user from ec2-user to ubuntu's default user ubuntu
sudo usermod -aG docker ubuntu
#now new added user will take effect next session
sudo systemctl restart docker

mkdir -p /home/ubuntu/.ssh
touch /home/ubuntu/.ssh/authorized_keys
cat /tmp/key.pub >> /home/ubuntu/.ssh/authorized_keys
chown -R ubuntu:ubuntu /home/ubuntu/.ssh
chmod 700 /home/ubuntu/.ssh
chmod 600 /home/ubuntu/.ssh/authorized_keys