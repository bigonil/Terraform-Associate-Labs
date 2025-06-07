terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1" # Cambia se necessario
}

locals {
  env = terraform.workspace
}

#######################
# S3 Bucket for State #
#######################

resource "aws_s3_bucket" "tf_state" {
  bucket = "terraform-state-${local.env}-631737274131"
  force_destroy = false

  tags = {
    Name        = "terraform-state-${local.env}-631737274131"
    Environment = local.env
  }
}

resource "aws_s3_bucket_versioning" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

#########################
# DynamoDB Table for Locking #
#########################

resource "aws_dynamodb_table" "tf_lock" {
  name         = "terraform-locks-${local.env}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "terraform-locks-${local.env}"
    Environment = local.env
  }
}

############################
# Optional IAM Role (safe) #
############################

resource "aws_iam_role" "tf_role" {
  name = "TerraformRole-${local.env}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name        = "TerraformRole-${local.env}"
    Environment = local.env
  }
}