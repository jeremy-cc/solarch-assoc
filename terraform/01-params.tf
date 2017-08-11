variable default_region {
  type="string"
  default="eu-west-1"
}

variable "nat_elastic_ip" {
  default="eipalloc-6ef6a454"
}

variable "public_access_cidrs" {
  type="list"
}

variable vpc_cidr_block {
  type="string"
}

variable "app_subnets" {
  type="list"
}

variable "access-key-name" {
  type="string"
}

variable ami_id {
  type="string"
}

variable "aws_zones" {
  type = "list"
  default=[ "eu-west-1a","eu-west-1b","eu-west-1c"]
}

variable "default_instance_type" {
  default="t2.small"
}

variable "web_asg_min" {
  default = 2
}

variable "web_asg_max" {
  default = 2
}