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

resource "aws_s3_bucket" "bucket" {
  bucket = "lb-43802482094298-depends-on"
}

resource "aws_instance" "my_server" {
  ami           = "ami-087c17d1fe0178315"
  instance_type = "t2.micro"
  depends_on = [
    aws_s3_bucket.bucket
  ]
}

output "public_ip" {
  value = aws_instance.my_server.public_ip
}