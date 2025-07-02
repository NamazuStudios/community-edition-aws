
variable "aws_region" {
  type = string
  description = "The AWS region to operate against."
}

variable "aws_profile" {
  type = string
  description = "The locally configured AWS Profile to use for auth."
}

variable "availability_zone" {
  type = string
  default = null
  description = "The availability zone for the build farm."
}

variable "deployment_name" {
  type = string
  description = "The name for this deployment."
}

variable "ssh_public_key" {
  type = string
  description = "The public key contents."
}

variable "vpc_cidr_range" {
  type = string
  description = "The CIDR Range for the Whole VPC."
  default = "10.0.0.0/16"
}

variable "ami" {
  description = "The AMI for the instance. Must be an Amazon Linux 2023 or later AMI."
  type = string
}

variable "instance_type" {
  description = "The default machine type."
  type = string
  default = "m6a.xlarge"
}

variable "root_block_device_size" {
  type = number
  description = "The size of the root block device."
  default = 64
}

variable "db_volume_size" {
  description = "The size of the database volume in GB."
  type = number
  default = 8
}

variable "log_volume_size" {
  description = "The size of the log volume in GB."
  type = number
  default = 16
}

variable "repository_volume_size" {
  description = "The size of the repository volume in GB."
  type = number
  default = 16
}

variable "hosted_zone_id" {
  description = "The Route53 Hosted Zone ID"
  type        = string
}

variable "hosted_zone_name" {
  description = "The domain name of the Hosted Zone (e.g., example.com.)"
  type        = string
}

variable "repo_tag" {
  description = "Git tag to check out."
  default     = "3.2.0-deployment"
}

variable "repo_url" {
  description = "Git repo URL"
  default     = "https://github.com/NamazuStudios/docker-compose.git"
}
