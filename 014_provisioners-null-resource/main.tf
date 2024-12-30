terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.70.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "lb-aws-admin"
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
      cidr_blocks      = ["0.0.0.0/0"]
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
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDYHI5yZIX8bu92xX1mMLxSU/V4dNUPW+UIYRuYQzVBB307eIcmp/9s01yMcFogsPTt4hrTZECAEsCgfAT0H/h5CZVFohxfkdeLkWhgLNuBD/qPqeg0rV8GgxhHtYbfgAR7uqquQCQNAjgS3IOnjxbN2KCq5Zw+X2UTQsPrZBt2X38NdQknni6pN1E6eksaqeS5lOqoUM5ZCKMiBeWl+QoDHiS74quWVY6v5z55qMnqHj5MrSW1Sr5lv5fRj7TaTasq90H9GVNHGhoq0uBqhkjLXd/2quska0+6ybqymRR0eGLP2cWb1WcQ7OhqgUTPuo0fNNcvK/iuUU1rOX3mK+Da10+Rmmcm/HFi/Gc1EYzc6aaKyS+KMPRYmVkn3ltq876qKbXmL1KQwPQD3u6zCvPMrQrp5ztTKa6Td4C5qwPawVBdh7SoXD1hvr0NLHZc+KfapDJt0NSXRU/m06CHm9LVOWqvRUNNLHj5ORpxBySovUd7Ubv6kvc/FUfDsp49yOXkL9xUrW48xpjsFWCLYUBqVI8UE/fp9YVKmy5riWpKgB9mP2GPKfAsPxTf12ffzUigUeW+RtlGOawNw184D8f9AsKDqlJozx3IJboADf0C1PcnIsrGbSh+Bl3fj5ZwveuS4x/E8Gf4oexlROMpT4R3ZdwZVD/ekOrCRs7UYEhvPw== luca.bigoni@gmail.com"
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
      private_key = file("id_rsa")
    }
  }



  tags = {
    Name = "MyServer"
  }
}

resource "null_resource" "status" {
  provisioner "local-exec" {
    command = "aws ec2 wait instance-status-ok --profile lb-aws-admin --region us-east-1 --instance-ids ${aws_instance.my_server.id}"
  }
  depends_on = [
    aws_instance.my_server
  ]
}

output "public_ip" {
  value = aws_instance.my_server.public_ip
}