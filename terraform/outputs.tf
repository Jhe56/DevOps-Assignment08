output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "bastion_public_dns" {
  value = aws_instance.bastion.public_dns
}

output "bastion_sg_id" {
  value = module.bastion_sg.security_group_id
}

output "private_instance_private_ips" {
  value = aws_instance.private_nodes[*].private_ip
}

output "private_instance_ids" {
  value = aws_instance.private_nodes[*].id
}

output "private_sg_id" {
  value = module.private_sg.security_group_id
}