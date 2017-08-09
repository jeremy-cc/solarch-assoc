resource "aws_vpc" "vpc" {
  cidr_block = "${var.vpc_cidr_block}"

  tags {
    Env = "solarch"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Env = "solarch"
  }
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags {
    Name        = "public-route-table"
    Environment = "solarch"
  }
}