
resource "aws_route53_record" "app_dns" {

  zone_id = var.hosted_zone_id
  name    = "${var.deployment_name}.${var.hosted_zone_name}"
  type    = "A"

  alias {
    name                   = aws_lb.app_alb.dns_name
    zone_id                = aws_lb.app_alb.zone_id
    evaluate_target_health = true
  }

}

resource "aws_route53_record" "ssh_dns" {

  zone_id = var.hosted_zone_id
  name    = "${var.deployment_name}-ssh.${var.hosted_zone_name}"
  type    = "A"
  ttl     = 300

  records = [
    aws_instance.app_server.public_ip
  ]

}
