terraform {

  backend "remote" {
    organization = "LB-GlobexInfraOps"

    workspaces {
      name    = "provisioners-cloud-init"
      project = "terraform-associate-labs"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.70.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_vpc" "main" {
  id = "vpc-0cd1d459812cff83a"
}


resource "aws_security_group" "sg_my_server" {
  name        = "sg_my_server"
  description = "MyServer Security Group"
  vpc_id      = data.aws_vpc.main.id

  ingress = [
    {
      description      = "HTTP"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "SSH"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["151.42.204.244/32"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress = [
    {
      description      = "outgoing traffic"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]
}

resource "aws_key_pair" "deployer" {
  key_name   = "lb-tf-key-pair"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCgGTbYPH84tomXiQOnVaOSNlDLtzBPBLJl3FpEanqLsLqJ8rep1eao4ZN8UTS/BC3JzdxpE/A5z0JSQVqVyaHfwkHx2w69eKSYmbcMdh87eLm0WBbFhkjHLaxQfjviS+q+oCXbQTdHVgae6xcyHDatzpLtsnL6jw4hAEKdk5nva9od3HAhirh9YJYmXF4RIX8T1V+bOIs2L4VO8VTMuxOgGW5oy3RZ5R1phnHlQySce7JSncruKXcNhJfsL8VA66+3uteoES8MoaGZimqS20eBoLp2Pz1mco18QXqfANPuroMWBajMkUPR4zXuqHitM+bT1M3HxaX/xe2yxKerUtZL"
}

data "template_file" "user_data" {
  template = file("./userdata.yaml")
}


resource "aws_instance" "my_server" {
  ami                    = "ami-087c17d1fe0178315"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.sg_my_server.id]
  user_data              = data.template_file.user_data.rendered
  provisioner "file" {
    content     = "mars"
    destination = "/home/ec2-user/barsoon.txt"
    connection {
      type        = "ssh"
      user        = "ec2-user"
      host        = self.public_ip
      private_key = file(".ssh/terraform/lb-tf-key-pair-private_key.pem")
    }
  }

  tags = {
    Name = "MyServer"
  }
}

output "public_ip" {
  value = aws_instance.my_server.public_ip
}