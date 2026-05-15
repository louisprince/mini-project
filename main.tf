terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.0.0/23" # https://mxtoolbox.com/subnetcalculator.aspx
  availability_zone       = "eu-west-2a"
  map_public_ip_on_launch = true
}

resource "aws_instance" "ci" {
  ami           = "ami-0c76bd4bd302b30ec"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public_1.id
  key_name      = "ldp-key"

  tags = {
    Name = "ci-server"
  }
}
