resource "aws_subnet" "public" {
  count                   = "${length(var.public_subnets)}"
  vpc_id                  = "${var.vpc_id}"
  cidr_block              = "${element(var.public_subnets, count.index)}"
  availability_zone       = "${element(split(",",lookup(var.aws_zones,var.aws_region)), count.index)}"
  map_public_ip_on_launch = "false"

  tags {
    Name        = "${var.subnet_name}-${element(split(",",lookup(var.aws_zones,var.aws_region)), count.index)}"
    Environment = "solarch"
  }
}

resource "aws_route_table_association" "public" {
  count          = "${length(var.public_subnets)}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${var.route_table_id}"
}