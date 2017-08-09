variable "private_subnets" {
  type    = "list"
  default = []
}

variable "vpc_id" {
  type="string"
}

variable "aws_region" {
  default = "eu-west-1"
}

variable "aws_zones" {
  type = "map"

  default = {
    eu-west-1 = "eu-west-1a,eu-west-1b,eu-west-1c"
  }
}

variable "subnet_name" {
  type="string"
}
