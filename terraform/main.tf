module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.project_name}-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.11.0/24", "10.0.12.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Project = var.project_name
  }
}

module "bastion_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.1"

  name        = "${var.project_name}-bastion-sg"
  description = "Allow SSH only from my IP"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "bastion_ssh" {
  security_group_id = module.bastion_sg.security_group_id
  cidr_ipv4 =  var.my_ip

  ip_protocol = "tcp"
  from_port = 22
  to_port     = 22

  description = "SSH from my IP"
}

resource "aws_vpc_security_group_egress_rule" "bastion_egress" {
  security_group_id = module.bastion_sg.security_group_id
  ip_protocol = "-1"
  cidr_ipv4 = "0.0.0.0/0"
}

module "private_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.1"

  name        = "${var.project_name}-private-sg"
  description = "Allow SSH only from bastion"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "${var.project_name}-private-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "bastion_ssh_private_instance" {
  security_group_id = module.private_sg.security_group_id
  referenced_security_group_id = module.bastion_sg.security_group_id

  ip_protocol = "tcp"
  from_port = 22
  to_port     = 22

  description = "SSH from bastion to private instance"
}

resource "aws_vpc_security_group_egress_rule" "private_instance_egress" {
  security_group_id = module.private_sg.security_group_id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "-1"
}

resource "aws_instance" "bastion" {
  ami                         = var.custom_ami_id
  instance_type               = var.instance_type
  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = module.bastion_sg.security_group_id
  associate_public_ip_address = true
  key_name                    = var.key_name

  tags = {
    Name = "${var.project_name}-bastion"
    Role = "bastion"
  }
}

resource "aws_instance" "private_nodes" {
  count = 6

  ami                    = var.custom_ami_id
  instance_type          = var.instance_type
  subnet_id              = module.vpc.private_subnets[count.index % length(module.vpc.private_subnets)]
  vpc_security_group_ids = module.private_sg.security_group_id
  key_name               = var.key_name

  tags = {
    Name = "${var.project_name}-private-${count.index + 1}"
    Role = "private"
  }
}
