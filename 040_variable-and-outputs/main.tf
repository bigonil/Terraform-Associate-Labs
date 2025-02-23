terraform {
  #  cloud {
  #    hostname     = "app.terraform.io"
  #    organization = "LB-GlobexInfraOps"

  #    workspaces {
  #      name    = "getting-started"
  #      project = "terraform-associate-labs"
  #    }
  # }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.70.0"
    }
  }
}
variable "instance_type" {
  type = string
  description = "Size of instance"
}
provider "aws" {
  profile = "lb-aws-admin"
  region  = "us-east-1"
}
resource "aws_instance" "my_server" {
  ami           = "ami-087c17d1fe0178315"
  instance_type = var.instance_type
}