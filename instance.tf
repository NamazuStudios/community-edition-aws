
locals {
  user_data = templatefile("${path.module}/user_data.bash.template", {
    repo_url    = var.repo_url
    repo_tag    = var.repo_tag
    elements_config_secret_name = aws_secretsmanager_secret.elements_config.name
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

}

resource "aws_instance" "app_server" {

  ami = var.ami
  key_name = aws_key_pair.eks_ssh_key.id
  instance_type = var.instance_type
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
    Name = "${var.deployment_name}-${count.index}"
  }

  lifecycle {
    replace_triggered_by = [aws_secretsmanager_secret_version.elements_config]
  }

}

resource "aws_volume_attachment" "db_data" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.db_data.id
  instance_id = aws_instance.app_server.id
}

resource "aws_volume_attachment" "logs" {
  device_name = "/dev/sdg"
  volume_id   = aws_ebs_volume.logs.id
  instance_id = aws_instance.app_server.id
}

resource "aws_volume_attachment" "repos" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.repos.id
  instance_id = aws_instance.app_server.id
}
