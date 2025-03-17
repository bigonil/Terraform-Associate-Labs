terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.80.0"
    }
  }
}

provider "aws" {
  profile = "lb-aws-admin"
  region  = "us-east-1"
}
resource "aws_instance" "my_server" {
  count         = 2
  ami           = "ami-087c17d1fe0178315"
  instance_type = "t2.micro"
  tags = {
    Name = "Server-${count.index}"
  }
}