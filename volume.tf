
resource "aws_ebs_volume" "db_data" {
  availability_zone = aws_instance.app_server.availability_zone
  size              = 20
  type              = "gp3"
  tags = {
    Name = "${var.deployment_name}-db-data"
  }
}

resource "aws_ebs_volume" "logs" {
  availability_zone = aws_instance.app_server.availability_zone
  size              = 10
  type              = "gp3"
  tags = {
    Name = "${var.deployment_name}-logs"
  }
}

resource "aws_ebs_volume" "repos" {
  availability_zone = aws_instance.app_server.availability_zone
  size              = 20
  type              = "gp3"
  tags = {
    Name = "${var.deployment_name}-repos"
  }
}
