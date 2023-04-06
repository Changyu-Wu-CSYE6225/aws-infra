# Security Group
resource "aws_security_group" "web_app_sg" {
  name        = "web_app_sg"
  description = "Allow HTTPS to web server"
  vpc_id      = aws_vpc.main.id

  ingress = [
    {
      description      = "HTTPS ingress"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = [var.aws_vpc_main_cidr_block]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = [aws_security_group.load_balancer_sg.id]
      self             = false
    },
    {
      description      = "Web server"
      from_port        = 5001
      to_port          = 5001
      protocol         = "tcp"
      cidr_blocks      = [var.aws_vpc_main_cidr_block]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = [aws_security_group.load_balancer_sg.id]
      self             = false
    }
  ]

  egress {
    description      = ""
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }

  tags = {
    Name = "Web app security group"
  }
}

# RDS sg
resource "aws_security_group" "db_sg" {
  name        = "db_sg"
  description = "RDS Security Group"
  vpc_id      = aws_vpc.main.id

  ingress = [
    {
      description      = "MySQL"
      from_port        = 3306
      to_port          = 3306
      protocol         = "tcp"
      cidr_blocks      = []
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = [aws_security_group.web_app_sg.id]
      self             = false
    }
  ]

  tags = {
    Name = "Database security group"
  }
}

# Load Balancer sg
resource "aws_security_group" "load_balancer_sg" {
  name        = "load_balancer_sg"
  description = "Application Load Balancer Security Group"
  vpc_id      = aws_vpc.main.id

  ingress = [
    {
      description      = "HTTPS ingress"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "HTTPS ingress"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
  ]

  egress {
    description      = ""
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }

  tags = {
    Name = "Load Balancer Security Group"
  }
}
