terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.58.0"
    }
  }
}

provider "aws" {
  profile = "lb-aws-admin" # Use your AWS profile name
  # region = "us-west-2"  # Uncomment this line if you want to specify a different region
  region = "us-east-1"
}
resource "aws_instance" "our_server" {
  ami           = "ami-087c17d1fe0178315"
  instance_type = "t2.micro"
  tags = {
    Name = "MyServer"
  }
}

output "public_ip" {
  value = aws_instance.our_server[*].public_ip
}