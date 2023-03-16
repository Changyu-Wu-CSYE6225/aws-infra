resource "aws_route53_record" "dev_a_record" {
  zone_id = var.zone_id
  name    = var.domain
  type    = "A"
  ttl     = 60
  records = [aws_instance.web_app.public_ip]
}
