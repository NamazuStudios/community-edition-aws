
variable "aws_region" {
  type = string
  description = "The AWS region to operate against."
  default = "us-east-1"
}

variable "aws_profile" {
  type = string
  description = "The locally configured AWS Profile to use for auth."
}

variable "availability_zone" {
  type = string
  description = "The Availability Zone to deploy into."
  default = "us-east-1a"
}

variable "deployment_name" {
  type = string
  description = "The name for this deployment which also defines the DNS prefix."
}

variable "ssh_public_key_file" {
  type = string
  description = "The public key contents."
  default = "ssh_key.pub"
}

variable "ami" {
  description = "The AMI for the instance. Must be an Amazon Linux 2023 or later AMI."
  type = string
  default = "ami-05ffe3c48a9991133"
}

variable "instance_type" {
  description = "The machine type."
  type = string
  default = "t3.micro"
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
  default     = "3.3.11"
}

variable "repo_url" {
  description = "Git repo URL"
  default     = "https://github.com/NamazuStudios/docker-compose.git"
}

variable "docker_image_version" {
  description = "Git tag to check out."
  default     = "3.3.11"
}

variable docker_environment {
  description = "Specifies additional environment variables. Overrides default settings."
  type = map(string)
  default = {}
}

variable elements_properties {
  description = "Specifies configuration variables for Namazu Elements. Overrides default settings."
  type = map(string)
  default = {}
}
