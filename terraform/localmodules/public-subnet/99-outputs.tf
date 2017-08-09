
output "availability_zones" {
  value = ["${aws_subnet.public.*.availability_zone}"]
}

## Subnet Outputs
output "public_subnets" {
  value = ["${aws_subnet.public.*.id}"]
}
