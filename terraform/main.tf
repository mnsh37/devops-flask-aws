terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket       = "mnsh37-devops-flask-tfstate-x7k29p"
    key          = "devops-flask/terraform.tfstate"
    region       = "ap-south-1"
    use_lockfile = true
  }
}

provider "aws" {
  region = "ap-south-1"
}

# Find the existing default VPC
data "aws_vpc" "default" {
  default = true
}

# Create a security group for the Flask website
resource "aws_security_group" "web" {
  name        = "devops-flask-web-sg"
  description = "Allow public HTTP access to the Flask website"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "Allow HTTP from the internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "devops-flask-web-sg"
    Project = "devops-flask-aws"
  }
}
