# AMI
# data "aws_ami" "ami" {
#   most_recent = true
#   filter {
#     name   = "name"
#     values = ["csye6225_*"]
#   }
# }

# EC2 instance Profile
resource "aws_iam_instance_profile" "iam_instance_profile" {
  name = "iam_instance_profile"
  role = aws_iam_role.csye6225_s3_role.name
}

# EC2 key pair
resource "aws_key_pair" "ec2_key_pair" {
  key_name   = "ec2"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDk48gYxwWMUbTFA3rRRlJKgcOFt7MbC2YKKdaeLmJx37URZav0Dj4EsOdazArxdUMF/UD+qlXgSbZMbsRo6gx25nI28uOJUoFSErOoRh2vX7MsfU9RGH/yus+Qryw/UZH7mUOIh9zDKuvD9EOLkCcFlyxHq354PZjLVVUw7A2XNI5xpljU50bu2bG6I0GLChuFuwRQ1sQeDT5LkGIifPjQ7gwgzdYSptjEBSMN2TsUAMZ9RbxAjKseLJjOG913/gBx56ODVybY4YqIPqyYxUEpsDpxc/IIA207m+iP348uNtGTB6Xpr75JOj0OOCwAHFIs5E28r8uvm13r9j9SWZSsPqu7dCWOOG4aAIRUbzkKz9cNfDAYeAoZ0dnfFGukizwOk4YsD/wd451tMr7CUvAfFxp+skhKUlwuGeTl+dB4tFOleF+07fG1rAudTxy3efQKF03bHgb+3xAqAweoYEIoLbartXeMUfND3sg4midmR9RowahbdEFtgZCSOAWyS4M= changyu@ChangyudeMacBook-Air.local"
}

# Create EC2 instance
resource "aws_instance" "web_app" {
  #   ami                         = data.aws_ami.ami.id
  ami                         = var.ami_id
  instance_type               = "t2.micro"
  subnet_id                   = element(aws_subnet.public_subnet[*].id, 0)
  vpc_security_group_ids      = [aws_security_group.web_app_sg.id]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.iam_instance_profile.name
  key_name                    = aws_key_pair.ec2_key_pair.key_name

  user_data = <<EOF
      #!bin/bash
      echo DB_USERNAME=${aws_db_instance.rds_mysql.username} >> /home/ec2-user/webapp/.env
      echo DB_PASSWORD=${aws_db_instance.rds_mysql.password} >> /home/ec2-user/webapp/.env
      echo DB_HOSTNAME=${aws_db_instance.rds_mysql.address} >> /home/ec2-user/webapp/.env
      echo S3_BUCKET_NAME=${aws_s3_bucket.private_bucket.bucket} >> /home/ec2-user/webapp/.env
      echo BUCKET_REGION=${var.aws_region} >> /home/ec2-user/webapp/.env
      
      sudo systemctl start webapp.service
    EOF

  root_block_device {
    delete_on_termination = true
    volume_size           = 50
    volume_type           = "gp2"
  }

  tags = {
    Name = "Web app"
  }
}
