variable default_region {
  type="string"
  default="eu-west-1"
}

variable ami_id {
  type="string"
}

variable "az1" {
  type="string"
  default="eu-west-1a"
}

variable "az2" {
  type="string"
  default="eu-west-1b"
}

variable vpc_cidr_block {
  type="string"
}

variable public_subnets {
  type="list"
}

variable private_subnets {
  type="list"
}