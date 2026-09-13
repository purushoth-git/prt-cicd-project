output "k8s_public_ip" {
  value = aws_instance.k8s_node.public_ip
}

output "k8s_private_ip" {
  value = aws_instance.k8s_node.private_ip
}
