resource "aws_subnet" "public" {
  count                   = "${length(var.public_subnets)}"

  vpc_id                  = "${aws_vpc.vpc.id}"

  cidr_block              = "${element(var.public_subnets, count.index)}"

  availability_zone       = "${element(var.aws_zones, count.index)}"

  map_public_ip_on_launch = "false"

  lifecycle {
    create_before_destroy = true
  }

  tags {
    Name        = "public-${element(var.aws_zones, count.index)}"
    Environment = "solarch"
  }
}

resource "aws_route_table_association" "public" {
  count          = "${length(var.public_subnets)}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}
