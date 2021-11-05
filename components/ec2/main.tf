
# TODO: Add provisioning of the elastic IP and the DNS records.

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

variable "SLEIPNIR" {
  type = string
}

provider "aws" {
  profile = "default"
  region  = "eu-central-1"
}

resource "aws_security_group" "sleipnir" {
  name        = "sleipnir-security-group"
  description = "Allow HTTP, HTTPS and SSH traffic"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sleipnir"
  }
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = "${aws_instance.sleipnir.id}"
  allocation_id = "eipalloc-78a96a79"
}

resource "aws_instance" "sleipnir" {
  key_name      = "sleipnir"
  ami           = "ami-05f7491af5eef733a"
  instance_type = "t2.medium"

  tags = {
    Name = "sleipnir"
  }

  vpc_security_group_ids = [
    aws_security_group.sleipnir.id
  ]

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_type = "gp2"
    volume_size = 30
  }
}
