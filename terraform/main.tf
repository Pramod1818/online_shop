# resource "aws_key_pair" "key" {
#   key_name   = var.key_name
#   public_key = file("terra-key.pub")
# }

resource "aws_default_vpc" "default" {
}

resource "aws_security_group" "security_group" {
  name   = "terra-sg"
  vpc_id = aws_default_vpc.default.id

  ingress {
    description = "port 22 allow"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "port 80 allow"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "port 443 allow"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = " allow all outgoing traffic "
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = "my_sg"
  }
}

resource "aws_instance" "instance" {
  ami             = var.ami #ubuntu img
  instance_type   = var.instance_type
  key_name        = var.key_name
  security_groups = [aws_security_group.security_group.name]
  root_block_device {
    volume_size = 10
    volume_type = "gp3"
  }
  tags = {
    Name        = "EC2-${terraform.workspace}"
    Environment = var.env
  }
}

# terraform {
#   backend "s3" {
#     bucket         = "terraform-state-bucket-may-2025"
#     key            = "terraform.tfstate"
#     region         = "eu-west-1"
#     dynamodb_table = "terraform-locks-table"
#     encrypt        = true
#   }
# }

