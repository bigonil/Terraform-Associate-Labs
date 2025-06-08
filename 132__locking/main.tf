terraform { 
  cloud { 
    
    organization = "LB-GlobexInfraOps" 

    workspaces { 
      name = "terraform-aws-force-unlock" 
    } 
  } 
}

provider "aws" {
	region = "us-east-1"
}

module "apache" {
  source           = "./apache"
  subnet_id        = var.subnet_id
  instance_type    = var.instance_type
  public_key       = var.public_key
  server_name      = var.server_name
}

output "public_ip" {
  value = module.apache.public_ip
}