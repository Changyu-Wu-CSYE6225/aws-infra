# Application Load Balancer
resource "aws_lb" "webapp_lb" {
  name               = "webapp-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.load_balancer_sg.id]
  subnets            = [for subnet in aws_subnet.public_subnet : subnet.id]

  tags = {
    Application = "webapp"
  }
}

# Load Balancer Target Group
resource "aws_lb_target_group" "webapp_lb_tg" {
  name        = "webapp-lb-tg"
  target_type = "instance"
  port        = var.port
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 5
    timeout             = 5
    interval            = 30
    path                = "/healthz"
    port                = var.port
    matcher             = "200"
  }
}

# Find a certificate that is issued
# data "aws_acm_certificate" "webapp_lb_certificate" {
#   domain = var.domain
#   #   statuses = ["ISSUED"]
#   statuses = ["PENDING_VALIDATION"]
# }

# Load Balancer Listener
resource "aws_lb_listener" "webapp_lb_listener" {
  load_balancer_arn = aws_lb.webapp_lb.arn
  port              = 80
  protocol          = "HTTP"
  #   port              = "443"
  #   protocol          = "HTTPS"
  #   ssl_policy        = "ELBSecurityPolicy-2016-08"
  #   certificate_arn   = data.aws_acm_certificate.webapp_lb_certificate.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webapp_lb_tg.arn
  }
}
