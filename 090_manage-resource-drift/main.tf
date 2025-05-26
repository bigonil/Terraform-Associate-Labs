terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.58.0"
    }
  }
}

provider "aws" {
  profile = "lb-aws-admin"
  region  = "us-east-1"
}
resource "aws_instance" "my_server" {
  ami           = "ami-087c17d1fe0178315"
  instance_type = "t2.micro"
	tags = {
		Name = "MyServer"
	}
}

resource "aws_s3_bucket" "bucket" {
  bucket = "greatly-sincerely-mainly-relaxed-oryx"
}

output "public_ip" {
  value = aws_instance.my_server.public_ip
}