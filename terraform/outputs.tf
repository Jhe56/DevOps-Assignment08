output "ansible_controller_public_ip" {
  value = aws_instance.ansible_controller.public_ip
}

output "ansible_controller_public_dns" {
  value = aws_instance.ansible_controller.public_dns
}

output "ansible_controller_sg_id" {
  value = module.ansible_controller_sg.security_group_id
}

output "awsl_instance_ips" {
  value = aws_instance.awsl_private_nodes[*].private_ip
}

output "awsl_instance_ids" {
  value = aws_instance.awsl_private_nodes[*].id
}

output "ubuntu_instance_ips" {
  value = aws_instance.ubuntu_private_nodes[*].private_ip
}

output "ubuntu_instance_ids" {
  value = aws_instance.ubuntu_private_nodes[*].id
}

output "private_sg_id" {
  value = module.private_sg.security_group_id
}