provider "aws" {
  region = "eu-west-1"
}

# Create Key Pair
resource "aws_key_pair" "terra_key" {
  key_name   = "terra-key"
  public_key = file("..\\terra-key.pub")
}

# Use default VPC
resource "aws_default_vpc" "default" {}

# Create Security Group
resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Allow inbound traffic"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web_sg"
  }
}

# EC2 Instance with lifecycle and dependency
resource "aws_instance" "web_server" {
  ami           = "ami-0df368112825f8d8f" # Ubuntu AMI for eu-west-1 (Ireland)
  instance_type = "t2.micro"
  key_name      = aws_key_pair.terra_key.key_name

  security_groups = [aws_security_group.web_sg.name]

  # Lifecycle to safely manage updates
  lifecycle {
    create_before_destroy = true
    prevent_destroy       = false
    ignore_changes        = [ami] # Optional - ignore changes to AMI
  }

  # Explicit dependency to ensure SG is created before instance
  depends_on = [
    aws_security_group.web_sg
  ]

  root_block_device {
    volume_size = 10
    volume_type = "gp3"
  }

  tags = {
    Name = "EC2_Task5"
  }
}
