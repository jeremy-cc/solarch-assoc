module "public-subnet" {
  source = "./localmodules/public-subnet"

  route_table_id = "${aws_route_table.public.id}"

  vpc_id = "${aws_vpc.vpc.id}"

  public_subnets = "${var.public_subnets}"

  subnet_name = "solarch-public"
}

module "private-subnet" {
  source = "./localmodules/private-subnet"

  vpc_id = "${aws_vpc.vpc.id}"

  private_subnets = "${var.public_subnets}"

  subnet_name = "solarch-private"
}