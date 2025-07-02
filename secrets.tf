
resource "aws_secretsmanager_secret" "elements_config" {

  name_prefix = "${var.deployment_name}."
  description = "Builder ${count.index} for ${var.deployment_name}"
}

resource "aws_secretsmanager_secret_version" "elements_config" {
  secret_id     = aws_secretsmanager_secret.elements_config[count.index].id
  secret_string = <<-EOF
  dev.getelements.elements.mongo.uri=mongodb://mongo:27017
  dev.getelements.elements.cors.allowed.origins=https://${var.deployment_name}.${var.hosted_zone_name}
  dev.getelements.elements.doc.url=https://${var.deployment_name}.${var.hosted_zone_name}/doc
  dev.getelements.elements.api.url=https://${var.deployment_name}.${var.hosted_zone_name}/api/rest
  dev.getelements.elements.code.serve.url=https://${var.deployment_name}.${var.hosted_zone_name}/code
  dev.getelements.elements.http.tunnel.url=https://${var.deployment_name}.${var.hosted_zone_name}/app
  EOF

}
