

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_subnet" "default_subnets" {
  for_each = toset(data.aws_subnets.default.ids)
  id       = each.value
}
