
resource "aws_instance" "web" {
  ami           = "ami-0e9bbd70d26d7cf4f" # Amazon Linux 2 AMI
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  key_name      = aws_key_pair.deployer.key_name

  tags = {
    Name = var.server_name
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = var.public_key
}

output "public_ip" {
  value = aws_instance.web.public_ip
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for the instance"
  type        = string
}

variable "server_name" {
  description = "Name tag for the server"
  type        = string
}

variable "public_key" {
  description = "Public key for SSH access"
  type        = string
}
