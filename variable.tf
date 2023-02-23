variable "provider_profile" {
  type = string
  #   default = "dev"
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "aws_vpc_main_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}
