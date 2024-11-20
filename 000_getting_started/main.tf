terraform {
  #backend "remote" {
  #  hostname = "app.terraform.io"
  #  organization = "ExamPro"

  #  workspaces {
  #    name = "getting-started"
  #  }
  #}
  cloud {
    hostname     = "app.terraform.io"
    organization = "LB-GlobexInfraOps"

    workspaces {
      name    = "getting-started"
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

locals {
  project_name = "terraform-associate-labs-getting-started"
}