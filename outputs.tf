
output "instance_ids" {
  value = aws_instance.app_server.id
}

output "instances_ips" {
  value = aws_instance.app_server.private_ip
}

output "instances_host_dns" {
  value = aws_instance.app_server.public_dns
}

output "alb_dns_name" {
  value = aws_lb.app_alb.dns_name
}

output "app_url" {
  value = "https://${aws_route53_record.app_dns.fqdn}"
}
