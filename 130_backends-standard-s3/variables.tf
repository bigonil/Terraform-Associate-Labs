variable "bucket" {
  type    = string
  default = "320489324827429471210198"
}


variable "public_key" {
  type = string
}


variable "server_name" {
  type = string
}

variable "workspace_iam_roles" {
  default = {
    staging    = "arn:aws:iam::STAGING-ACCOUNT-ID:role/Terraform"
    production = "arn:aws:iam::PRODUCTION-ACCOUNT-ID:role/Terraform"
  }
}

variable "vpc_id" {
  description = "The VPC ID to launch the NGINX server in"
  type        = string
}

variable "my_ip_with_cidr" {
  description = "Your IP address with CIDR mask (e.g. 1.2.3.4/32)"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for the NGINX server"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
}
