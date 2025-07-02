
resource "aws_key_pair" "eks_ssh_key" {
  key_name_prefix = "${var.deployment_name}-"
  public_key = var.ssh_public_key
}
