## VPC Ouputs
output "availability_zones" {
  value = ["${aws_subnet.private.*.availability_zone}"]
}

## Subnet Outputs
output "private_subnets" {
  value = ["${aws_subnet.private.*.id}"]
}
