output "public_ip" {
  value = values(aws_instance.my_server)[*].public_ip
}