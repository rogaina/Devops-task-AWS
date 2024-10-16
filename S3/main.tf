# main.tf

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.71.0"  # This specifies a compatible version of the AWS provider
    }
  }
}

provider "aws" {
  region = "us-east-2"  
}

resource "aws_s3_bucket" "product" {
  bucket = "rbadr-s3"  

  tags = {
    Name        = "rbadr"
    Environment = "prod"
  }
}

# Optional: Enable versioning for the S3 bucket
resource "aws_s3_bucket_versioning" "product" {
  bucket = aws_s3_bucket.product.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_object" "k8s" {
  bucket = "rbadr-s3"
  key    = "k8s/"  # for backup k8s cluster database
  content = ""  # 
}

resource "aws_s3_object" "bugs" {
  bucket = "rbadr-s3"
  key    = "bugs/"  
  content = ""  
}

resource "aws_s3_object" "apm" {
  bucket = "rbadr-s3"
  key    = "apm/"  
  content = ""  
}

resource "aws_s3_object" "crash" {
  bucket = "rbadr-s3"
  key    = "crash/"  
  content = ""  
}

resource "aws_s3_object" "survey" {
  bucket = "rbadr-s3"
  key    = "survey/"  
  content = ""  
}
