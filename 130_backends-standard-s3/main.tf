terraform {
  required_version = ">= 1.8.0"

  backend "s3" {

  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "lb-aws-admin"
}

locals {
  env = terraform.workspace
}

locals {
  public_subnet_ids = length(data.aws_subnets.public.ids) > 0 ? data.aws_subnets.public.ids : ["subnet-0ee8b17ed5b579e9b"] # Default to a specific subnet if none found,

}


####################
# Subnet Discovery #
####################

data "aws_subnets" "private" {
  filter {
    name   = "tag:Environment"
    values = [terraform.workspace]
  }

  filter {
    name   = "tag:Type"
    values = ["private"]
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "tag:Environment"
    values = [terraform.workspace]
  }

  filter {
    name   = "tag:Type"
    values = ["public"]
  }
}

##########################
# S3 Bucket (example use)
##########################

resource "aws_s3_bucket" "example" {
  bucket = "my-app-bucket-${local.env}-631737274131"
  force_destroy = true

  tags = {
    Environment = local.env
    Name        = "MyApp Bucket ${local.env}"
  }
}

############################
# NGINX EC2 Instance Module
############################

module "nginx_server" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.5.0"

  name          = "nginx-${local.env}"
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  key_name = var.key_name

  vpc_security_group_ids = [aws_security_group.nginx.id]
  subnet_id = local.public_subnet_ids[0]

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install nginx -y
              systemctl enable nginx
              systemctl start nginx
              EOF

  tags = {
    Name        = "nginx-${local.env}"
    Environment = local.env
  }
}

#######################
# Security Group for NGINX
#######################

resource "aws_security_group" "nginx" {
  name        = "nginx-sg-${local.env}"
  description = "Allow HTTP inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.my_ip_with_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "nginx-sg-${local.env}"
    Environment = local.env
  }
}

#########################
# AMI Lookup (Ubuntu LTS)
#########################

data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

##################
# Outputs
##################

output "public_ip" {
  value = module.nginx_server.public_ip
}

output "private_subnet_ids" {
  value = data.aws_subnets.private.ids
}

output "public_subnet_ids" {
  value = data.aws_subnets.public.ids
}
output "s3_bucket_name" {
  value = aws_s3_bucket.example.bucket
}