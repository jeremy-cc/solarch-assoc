resource "aws_subnet" "app" {
  count                   = "${length(var.app_subnets)}"

  vpc_id                  = "${aws_vpc.vpc.id}"

  cidr_block              = "${element(var.app_subnets, count.index)}"

  availability_zone       = "${element(var.aws_zones, count.index)}"

  map_public_ip_on_launch = "false"

  lifecycle {
    create_before_destroy = true
  }

  tags {
    Name        = "app-${element(var.aws_zones, count.index)}"
    Environment = "solarch"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = "${aws_vpc.vpc.id}"

  cidr_block              = "${var.bastion_subnet}"

  availability_zone       = "${element(var.aws_zones, count.index)}"

  map_public_ip_on_launch = "true"

  lifecycle {
    create_before_destroy = true
  }

  tags {
    Name        = "public-subnet"
    Environment = "solarch"
  }
}

resource "aws_route_table_association" "app" {
  count          = "${length(var.app_subnets)}"
  subnet_id      = "${element(aws_subnet.app.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "bastion" {

  subnet_id      = "${aws_subnet.public.id}"
  route_table_id = "${aws_route_table.public.id}"
}
