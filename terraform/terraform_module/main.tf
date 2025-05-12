provider "aws" {
  region = var.region
}

resource "aws_key_pair" "key" {
  key_name   = var.key_name
  public_key = file("terra-key.pub")
}

resource "aws_default_vpc" "default" {}

resource "aws_security_group" "security_group" {
  name   = "terra-sg"
  vpc_id = aws_default_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "ec2" {
  source         = "./modules/ec2_instance"
  ami            = var.ami
  instance_type  = var.instance_type
  key_name       = var.key_name
  security_group = aws_security_group.security_group.name
  name           = "EC2-${terraform.workspace}"
}
