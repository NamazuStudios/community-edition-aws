
locals {
  user_data = templatefile("${path.module}/user_data.bash.template", {
    repo_url    = var.repo_url
    repo_tag    = var.repo_tag
    base_url    = "https://${var.deployment_name}.${var.hosted_zone_name}"
    logs_volume_id    = aws_ebs_volume.logs.id
    repos_volume_id   = aws_ebs_volume.repos.id
    db_data_volume_id = aws_ebs_volume.db_data.id
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
