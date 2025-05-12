resource "aws_instance" "this" {
  ami           = "ami-0df368112825f8d8f"
  instance_type = var.instance_type
  key_name      = "terra-key-2"

  tags = {
    Name        = "${var.env}-nginx"
    Environment = var.env
  }
}

output "public_ip" {
  value = aws_instance.this.public_ip
}
