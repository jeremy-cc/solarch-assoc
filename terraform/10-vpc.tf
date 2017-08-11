resource "aws_vpc" "vpc" {
  cidr_block = "${var.vpc_cidr_block}"

  tags {
    Env = "solarch"
    Name = "solarch-vpc"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Env = "solarch"
    Name = "solarch-igw"
  }
}

resource "aws_nat_gateway" "app-nat-gw" {
  subnet_id = "${aws_subnet.public.id}"
  allocation_id = "${var.nat_elastic_ip}"
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

resource "aws_route_table" "apps" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.app-nat-gw.id}"
  }

  tags {
    Name        = "app-route-table"
    Environment = "solarch"
  }
}
