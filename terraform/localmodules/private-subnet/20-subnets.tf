resource "aws_subnet" "private" {
  count                   = "${length(var.private_subnets)}"
  vpc_id                  = "${var.vpc_id}"
  cidr_block              = "${element(var.private_subnets, count.index)}"
  availability_zone       = "${element(split(",",lookup(var.aws_zones,var.aws_region)), count.index)}"
  map_public_ip_on_launch = "false"

  tags {
    Name        = "${var.subnet_name}-${element(split(",",lookup(var.aws_zones,var.aws_region)), count.index)}"
    Environment = "solarch"
  }
}
