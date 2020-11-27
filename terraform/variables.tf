##################################################################################
# VARIABLES
##################################################################################

variable "private_key_path" {}
variable "key_name" {}
variable "aws_region" {
  default = "us-east-1"
}

variable "network_address_space" { 
    default = "10.0.0.0/16"
}

variable "public_subnet_address_space" { 
    type = list
    default = ["10.0.0.0/18", "10.0.64.0/18"]
}

variable "private_subnet_address_space" { 
    type = list
    default = ["10.0.128.0/18", "10.0.192.0/18"]
}