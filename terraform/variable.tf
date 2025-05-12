variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "instance_type" {
  description = "EC2 instance"
  type        = string
  default     = "t2.micro"
}

variable "ami" {
  description = "AMI ID for EC2"
  type        = string
  default     = "ami-0df368112825f8d8f" # Ubuntu in eu-west-1
}

variable "key_name" {
  description = "Key pair name"
  type        = string
  default     = "terra-key"
}

variable "env" {
    description = "environment"
    type = string
    default = "dev"
}