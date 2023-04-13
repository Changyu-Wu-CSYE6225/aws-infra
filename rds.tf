resource "aws_db_parameter_group" "rds_pg" {
  name   = "rds-pg-mysql"
  family = "mysql8.0"

  parameter {
    name  = "character_set_client"
    value = "utf8mb4"
  }
}

# RDS Instance
resource "aws_db_instance" "rds_mysql" {
  allocated_storage    = 20
  db_name              = "csye6225"
  engine               = "mysql"
  engine_version       = "8.0.32"
  instance_class       = "db.t3.micro"
  identifier           = "csye6225"
  username             = "csye6225"
  password             = var.rds_password
  parameter_group_name = aws_db_parameter_group.rds_pg.name
  db_subnet_group_name = aws_db_subnet_group.rds_private_subnet_group.name
  # security_group_names = [aws_security_group.db_sg.name]    # Deprecated
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  publicly_accessible    = false
  skip_final_snapshot    = true
  storage_encrypted      = true
  kms_key_id             = aws_kms_key.rds_kms_key.arn
}

# RDS Private subnet group
resource "aws_db_subnet_group" "rds_private_subnet_group" {
  name       = "private-subnet-group"
  subnet_ids = aws_subnet.private_subnet.*.id

  tags = {
    Name = "RDS private subnet group"
  }
}
