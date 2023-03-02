# VPC - main
resource "aws_vpc" "main" {
  cidr_block           = var.aws_vpc_main_cidr_block
  enable_dns_hostnames = true

  tags = {
    Name = "csye6225-vpc"
  }
}

# AZ
data "aws_availability_zones" "az" {
  state = "available"
  filter {
    name   = "region-name"
    values = [var.aws_region]
  }
}

locals {
  #   az_count = length(data.aws_availability_zones.az.names)
  az_count = 3

  public_subnet_cidrs = [
    for i in range(local.az_count) :
    cidrsubnet(var.aws_vpc_main_cidr_block, 8, i)
  ]

  private_subnet_cidrs = [
    for i in range(local.az_count) :
    cidrsubnet(var.aws_vpc_main_cidr_block, 8, i + 10)
  ]
}


# Subnet
resource "aws_subnet" "public_subnet" {
  count             = length(local.public_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = local.public_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.az.names[count.index]

  tags = {
    Name = "Public subnet ${count.index}"
  }
}

resource "aws_subnet" "private_subnet" {
  count             = length(local.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = local.private_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.az.names[count.index]

  tags = {
    Name = "Private subnet ${count.index}"
  }
}


# Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "vpc ig"
  }
}


# Route table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public route table"
  }
}

resource "aws_route_table_association" "public_rt_asso" {
  count          = length(local.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public_subnet[*].id, count.index)
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Private route table"
  }
}

resource "aws_route_table_association" "private_rt_asso" {
  count          = length(local.private_subnet_cidrs)
  subnet_id      = element(aws_subnet.private_subnet[*].id, count.index)
  route_table_id = aws_route_table.private_rt.id
}
