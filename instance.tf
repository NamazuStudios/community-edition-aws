
locals {

  base_url = "https://${var.deployment_name}.${var.hosted_zone_name}"

  default_docker_environment = {
    TAG=var.docker_image_version
    WS_LOG_DIR="/mnt/logs"
    DB_HOST_DIR="/mnt/db_data"
    CDN_REPOS_DIR="/mnt/repos/cdn"
    SCRIPT_REPOS_DIR="/mnt/repos/script"
  }

  default_elements_properties = {
    dev.getelements.elements.mongo.uri="mongodb://mongo:27017"
    dev.getelements.elements.app.url=local.base_url
    dev.getelements.elements.doc.url="${local.base_url}/doc"
    dev.getelements.elements.api.url="${local.base_url}/api/rest"
    dev.getelements.elements.code.serve.url="${local.base_url}/code"
    dev.getelements.elements.http.tunnel.url="${local.base_url}/app/rest"
    dev.getelements.elements.cors.allowed.origins=local.base_url
  }

  docker_environment_file = join("\n", [
    for key, value in merge(local.default_docker_environment, var.docker_environment) : "${key}=${value}"
  ])

  elements_properties_file = join("\n", [
    for key, value in merge(local.default_elements_properties, var.elements_properties) : "${key}=${value}"
  ])

  user_data = templatefile("${path.module}/user_data.bash.template", {
    repo_url    = var.repo_url
    repo_tag    = var.repo_tag
    base_url    = "https://${var.deployment_name}.${var.hosted_zone_name}"
    logs_volume_id    = aws_ebs_volume.logs.id
    repos_volume_id   = aws_ebs_volume.repos.id
    db_data_volume_id = aws_ebs_volume.db_data.id
    docker_environment    = local.docker_environment_file
    elements_properties   = local.elements_properties_file
  })
}

resource "aws_security_group" "app_server" {

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "Allow ALB to communicate on HTTP/8080"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    security_groups  = [aws_security_group.alb_sg.id]
  }

}

resource "aws_instance" "app_server" {

  ami = var.ami
  key_name = aws_key_pair.eks_ssh_key.id
  instance_type = var.instance_type
  availability_zone = var.availability_zone
  vpc_security_group_ids = [aws_security_group.app_server.id]

  user_data = local.user_data
  user_data_replace_on_change = true

  iam_instance_profile = aws_iam_instance_profile.app_server.id

  root_block_device {
    volume_size = var.root_block_device_size
  }
  
  metadata_options {
    http_tokens = "required"
    http_endpoint = "enabled"
    instance_metadata_tags = "enabled"
  }

  tags = {
    Name = "${var.deployment_name}.${var.hosted_zone_name}"
  }

}
