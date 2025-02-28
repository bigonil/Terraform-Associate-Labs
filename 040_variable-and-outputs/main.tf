terraform {

}

module "aws_server" {
  source        = "./aws_server"
  instance_type = "t3.micro"
}

output "public_ip" {
  value       = module.aws_server.public_ip
  description = "The public IP of the web server"
  #sensitive = true
}
