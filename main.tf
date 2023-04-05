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
  role = aws_iam_role.csye6225_role.name
}

# EC2 key pair
resource "aws_key_pair" "ec2_key_pair" {
  key_name   = "ec2"
  public_key = var.aws_key_pair_public_key
}

# Autoscaling group launch configuration
resource "aws_launch_template" "asg_launch_config" {
  name          = "asg_launch_config"
  image_id      = var.ami_id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.ec2_key_pair.key_name

  iam_instance_profile {
    arn = aws_iam_instance_profile.iam_instance_profile.arn
    # name = aws_iam_instance_profile.iam_instance_profile.name
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.web_app_sg.id]
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      delete_on_termination = true
      encrypted             = true
      volume_size           = 50
      volume_type           = "gp2"
    }
  }

  user_data = base64encode(
    <<EOF
      #!bin/bash
      echo DB_USERNAME=${aws_db_instance.rds_mysql.username} >> /home/ec2-user/webapp/.env
      echo DB_PASSWORD=${aws_db_instance.rds_mysql.password} >> /home/ec2-user/webapp/.env
      echo DB_HOSTNAME=${aws_db_instance.rds_mysql.address} >> /home/ec2-user/webapp/.env
      echo S3_BUCKET_NAME=${aws_s3_bucket.private_bucket.bucket} >> /home/ec2-user/webapp/.env
      echo BUCKET_REGION=${var.aws_region} >> /home/ec2-user/webapp/.env

      sudo systemctl start webapp.service
    EOF
  )

  tags = {
    Name = "Web app"
  }
}

# Create EC2 instance
# resource "aws_instance" "web_app" {
#   #   ami                         = data.aws_ami.ami.id
#   ami                         = var.ami_id
#   instance_type               = "t2.micro"
#   subnet_id                   = element(aws_subnet.public_subnet[*].id, 0)
#   vpc_security_group_ids      = [aws_security_group.web_app_sg.id]
#   associate_public_ip_address = true
#   iam_instance_profile        = aws_iam_instance_profile.iam_instance_profile.name
#   key_name                    = aws_key_pair.ec2_key_pair.key_name

#   user_data = <<EOF
#       #!bin/bash
#       echo DB_USERNAME=${aws_db_instance.rds_mysql.username} >> /home/ec2-user/webapp/.env
#       echo DB_PASSWORD=${aws_db_instance.rds_mysql.password} >> /home/ec2-user/webapp/.env
#       echo DB_HOSTNAME=${aws_db_instance.rds_mysql.address} >> /home/ec2-user/webapp/.env
#       echo S3_BUCKET_NAME=${aws_s3_bucket.private_bucket.bucket} >> /home/ec2-user/webapp/.env
#       echo BUCKET_REGION=${var.aws_region} >> /home/ec2-user/webapp/.env

#       sudo systemctl start webapp.service
#     EOF

#   root_block_device {
#     delete_on_termination = true
#     volume_size           = 50
#     volume_type           = "gp2"
#   }

#   tags = {
#     Name = "Web app"
#   }
# }
