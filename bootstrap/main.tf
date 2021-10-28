terraform {
 required_providers {
   aws = {
     source  = "hashicorp/aws"
     version = "~> 3.0"
   }
 }

 backend "s3" {
   bucket         = "sleipnir-infrastructure-state"
   key            = "state/terraform.tfstate"
   region         = "eu-central-1"
   encrypt        = true
   dynamodb_table = "sleipnir-infrastructure-state"
 }
}

provider "aws" {
 region = "eu-central-1"
}

resource "aws_s3_bucket" "sleipnir-infrastructure-state" {
 bucket = "sleipnir-infrastructure-state"
 acl    = "private"

 versioning {
   enabled = true
 }
}

resource "aws_s3_bucket_public_access_block" "block" {
 bucket = aws_s3_bucket.sleipnir-infrastructure-state.id

 block_public_acls       = true
 block_public_policy     = true
 ignore_public_acls      = true
 restrict_public_buckets = true
}

resource "aws_dynamodb_table" "sleipnir-infrastructure-state" {
 name           = "sleipnir-infrastructure-state"
 read_capacity  = 20
 write_capacity = 20
 hash_key       = "LockID"

 attribute {
   name = "LockID"
   type = "S"
 }
}

