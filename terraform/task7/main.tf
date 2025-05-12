provider "aws" {
  region = var.region
}

resource "aws_key_pair" "terra_key" {
  key_name   = "terra-key"
  public_key = file("..\\terra-key.pub")
}

resource "aws_default_vpc" "default" {}

resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Allow inbound traffic"
  vpc_id      = aws_default_vpc.default.id

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

  tags = {
    Name = "SG-${var.environment}"
  }
}

resource "aws_instance" "web_server" {
  ami             = "ami-0df368112825f8d8f"
  instance_type   = var.instance_type
  key_name        = aws_key_pair.terra_key.key_name
  security_groups = [aws_security_group.web_sg.name]

  root_block_device {
    volume_size = var.volume_size
    volume_type = "gp3"
  }

  tags = {
    Name        = "EC2-${var.environment}"
    Environment = var.environment
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_security_group.web_sg]
}
