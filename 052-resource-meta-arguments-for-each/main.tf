terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.90.0"
    }
  }
}

provider "aws" {
  profile = "lb-aws-admin"
  region  = "us-east-1"
}
resource "aws_instance" "my_server" {
	for_each = {
		nano = "t2.nano"
		micro =  "t2.micro"
		small =  "t2.small"
	}
  ami           = "ami-087c17d1fe0178315"
  instance_type = each.value
	tags = {
		Name = "Server-${each.key}"
	}
}