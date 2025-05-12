provider "aws" {
  region = var.region
}

module "ec2_instance" {
  source        = "../../modules/ec2"
  instance_type = var.instance_type
  env           = var.env
}

output "public_ip" {
  value = module.ec2_instance.public_ip
}
