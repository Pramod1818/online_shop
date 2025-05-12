variable "environment" {
  description = "The environment to deploy (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "region" {
  description = "AWS region to deploy in"
  type        = string
  default     = "eu-west-1"
}

variable "instance_type" {
  description = "Instance type based on environment"
  type        = string
  default     = ""
}

variable "volume_size" {
  description = "Root volume size"
  type        = number
  default     = 0
}
