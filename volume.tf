
resource "aws_ebs_volume" "db_data" {

  availability_zone = var.availability_zone
  size              = var.db_volume_size
  type              = "gp3"
  tags = {
    Name = "${var.deployment_name}-db-data"
  }

}

resource "aws_ebs_volume" "logs" {

  availability_zone = var.availability_zone
  size              = var.log_volume_size
  type              = "gp3"
  tags = {
    Name = "${var.deployment_name}-logs"
  }

}

resource "aws_ebs_volume" "repos" {

  availability_zone = var.availability_zone
  size              = var.repository_volume_size
  type              = "gp3"
  tags = {
    Name = "${var.deployment_name}-repos"
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
