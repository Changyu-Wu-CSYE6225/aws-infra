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

variable "ami_id" {
  type    = string
  default = "ami-057f2978248ea0350"
}

variable "rds_password" {
  type    = string
  default = "password"
}

variable "zone_id" {
  type    = string
  default = "Z03445163ORITSCCAVIB6"
}

variable "domain" {
  type    = string
  default = "dev.changyu.me"
}
