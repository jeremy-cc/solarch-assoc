
# security groups - permit private subnets to ssh + mysql to public subnets

resource "aws_security_group" "sg_public_subnet" {
  vpc_id = "${aws_vpc.vpc.id}"

  name = "${var.default_region}-public"

  tags {
    Name        = "${var.default_region}-public"
    Environment = "solarch"
  }
}

resource "aws_security_group_rule" "permit_http_office" {
  from_port = 80
  protocol = "tcp"
  to_port = 80

  security_group_id = "${aws_security_group.sg_public_subnet.id}"

  cidr_blocks = ["217.27.253.117/32"]

  type = "ingress"
}

resource "aws_security_group_rule" "permit_http_internal" {
  from_port = 80
  protocol = "tcp"
  to_port = 80

  security_group_id = "${aws_security_group.sg_public_subnet.id}"

  cidr_blocks = ["${aws_subnet.public.*.cidr_block}"]

  type = "ingress"
}


resource "aws_security_group_rule" "permit_ssh_office" {
  from_port = 22
  to_port = 22
  protocol = "tcp"

  security_group_id = "${aws_security_group.sg_public_subnet.id}"

  cidr_blocks = ["217.27.253.117/32"]

  type = "ingress"
}

resource "aws_security_group_rule" "permit_ssh_internal" {
  from_port = 22
  to_port = 22
  protocol = "tcp"

  security_group_id = "${aws_security_group.sg_public_subnet.id}"

  cidr_blocks = ["${aws_subnet.public.*.cidr_block}"]

  type = "ingress"
}