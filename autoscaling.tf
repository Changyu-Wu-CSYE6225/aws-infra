# Autoscaling group
resource "aws_autoscaling_group" "asg" {
  name             = "autoscaling_group"
  default_cooldown = 60
  min_size         = 1
  max_size         = 3
  desired_capacity = 1

  launch_template {
    id      = aws_launch_template.asg_launch_config.id
    version = "$Latest"
  }

  target_group_arns   = [aws_lb_target_group.webapp_lb_tg.arn]
  vpc_zone_identifier = [for subnet in aws_subnet.public_subnet : subnet.id]

  tag {
    key                 = "autoscaling_group"
    value               = "webapp_instance"
    propagate_at_launch = true
  }
}


# Autoscaling policy
resource "aws_autoscaling_policy" "scale_up_policy" {
  name                   = "scale_up_policy"
  scaling_adjustment     = 1
  cooldown               = 60
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.asg.name

  # Average CPU usage above 5%
  #   policy_type            = "TargetTrackingScaling"
  #   target_tracking_configuration {
  #     predefined_metric_specification {
  #       predefined_metric_type = "ASGAverageCPUUtilization"
  #     }
  #     target_value = 5.0
  #   }
}

resource "aws_autoscaling_policy" "scale_down_policy" {
  name                   = "scale_down_policy"
  scaling_adjustment     = -1
  cooldown               = 60
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.asg.name
}


# Autoscaling policy alarm
resource "aws_cloudwatch_metric_alarm" "scale_up_alarm" {
  alarm_name          = "scale_up_alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 5

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }

  alarm_description = "Scale up when CPU > 5% for 60 seconds"
  alarm_actions     = [aws_autoscaling_policy.scale_up_policy.arn]
}

resource "aws_cloudwatch_metric_alarm" "scale_down_alarm" {
  alarm_name          = "scale_down_alarm"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 3

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }

  alarm_description = "Scale down when CPU < 3% for 60 seconds"
  alarm_actions     = [aws_autoscaling_policy.scale_down_policy.arn]
}
