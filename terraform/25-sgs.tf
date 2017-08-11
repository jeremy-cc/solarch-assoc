
# security groups - permit private subnets to ssh + mysql to public subnets
resource "aws_security_group" "sg_app_subnet" {
  vpc_id = "${aws_vpc.vpc.id}"

  name = "${var.default_region}-app"

  tags {
    Name        = "${var.default_region}-app"
    Environment = "solarch"
  }
}

resource "aws_security_group" "sg_bastion" {
  vpc_id = "${aws_vpc.vpc.id}"

  name = "${var.default_region}-bastion"

  tags {
    Name        = "${var.default_region}-bastion"
    Environment = "solarch"
  }
}

resource "aws_security_group_rule" "permit_http_subnet" {
  from_port = 80
  protocol = "tcp"
  to_port = 80

  security_group_id = "${aws_security_group.sg_app_subnet.id}"

  cidr_blocks = ["0.0.0.0/0"]

  type = "ingress"
}

resource "aws_security_group_rule" "permit_ssh_office_to_bastion" {
  from_port = 22
  to_port = 22
  protocol = "tcp"

  security_group_id = "${aws_security_group.sg_bastion.id}"

  cidr_blocks = ["${var.public_access_cidrs}"]

  type = "ingress"
}

# permit icmp traffic to internal servers
resource "aws_security_group_rule" "permit_icmp" {
  from_port = -1
  to_port = -1

  protocol = "icmp"

  type="ingress"

  security_group_id = "${aws_security_group.sg_bastion.id}"

  cidr_blocks = ["${var.public_access_cidrs}"]
}

# permit unfiltered egress from bastion
resource "aws_security_group_rule" "unfiltered-egress-bastion" {
  from_port = 0
  to_port = 65535

  protocol = "tcp"

  type="egress"

  security_group_id = "${aws_security_group.sg_app_subnet.id}"
  cidr_blocks = ["0.0.0.0/0"]
}