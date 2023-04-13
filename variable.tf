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

variable "aws_key_pair_public_key" {
  type    = string
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDk48gYxwWMUbTFA3rRRlJKgcOFt7MbC2YKKdaeLmJx37URZav0Dj4EsOdazArxdUMF/UD+qlXgSbZMbsRo6gx25nI28uOJUoFSErOoRh2vX7MsfU9RGH/yus+Qryw/UZH7mUOIh9zDKuvD9EOLkCcFlyxHq354PZjLVVUw7A2XNI5xpljU50bu2bG6I0GLChuFuwRQ1sQeDT5LkGIifPjQ7gwgzdYSptjEBSMN2TsUAMZ9RbxAjKseLJjOG913/gBx56ODVybY4YqIPqyYxUEpsDpxc/IIA207m+iP348uNtGTB6Xpr75JOj0OOCwAHFIs5E28r8uvm13r9j9SWZSsPqu7dCWOOG4aAIRUbzkKz9cNfDAYeAoZ0dnfFGukizwOk4YsD/wd451tMr7CUvAfFxp+skhKUlwuGeTl+dB4tFOleF+07fG1rAudTxy3efQKF03bHgb+3xAqAweoYEIoLbartXeMUfND3sg4midmR9RowahbdEFtgZCSOAWyS4M= changyu@ChangyudeMacBook-Air.local"
}

variable "port" {
  type    = string
  default = 5001
}

variable "ssl_certificate_arn" {
  type    = string
  default = "ssl certificate arn"
}
