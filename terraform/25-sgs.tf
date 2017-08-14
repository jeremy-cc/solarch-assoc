
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

# permit bastion to be accessed from work
resource "aws_security_group_rule" "permit_ssh_office_to_bastion" {
  from_port = 22
  to_port = 22
  protocol = "tcp"

  security_group_id = "${aws_security_group.sg_bastion.id}"

  cidr_blocks = ["${var.public_access_cidrs}"]

  type = "ingress"
}

# permit bastion to be pinged from work
resource "aws_security_group_rule" "permit_icmp_office_to_bastion" {
  from_port = -1
  to_port = -1
  protocol = "icmp"

  security_group_id = "${aws_security_group.sg_bastion.id}"

  cidr_blocks = ["${var.public_access_cidrs}"]

  type = "ingress"
}

# permit bastion to access public internet
resource "aws_security_group_rule" "permit_bastion_egress" {
  from_port = 0
  to_port = 65535

  protocol = "tcp"

  security_group_id = "${aws_security_group.sg_bastion.id}"

  cidr_blocks = ["0.0.0.0/0"]

  type = "egress"
}


# permit icmp from bastion to other instances
resource "aws_security_group_rule" "permit_icmp_bastion_to_app" {
  from_port = -1
  to_port = -1

  protocol = "icmp"

  security_group_id = "${aws_security_group.sg_app_subnet.id}"
  source_security_group_id = "${aws_security_group.sg_bastion.id}"

  type="ingress"
}

# permit ssh from bastion to instances
resource "aws_security_group_rule" "permit_ssh_bastion_to_app" {
  from_port = 22
  to_port = 22

  protocol = "tcp"

  source_security_group_id = "${aws_security_group.sg_bastion.id}"
  security_group_id = "${aws_security_group.sg_app_subnet.id}"

  type="ingress"
}

# permit http from everywhere to app
resource "aws_security_group_rule" "permit_http_to_app" {
  from_port = 80
  to_port = 80
  protocol = "tcp"

  security_group_id = "${aws_security_group.sg_app_subnet.id}"
  cidr_blocks = ["0.0.0.0/0"]

  type="ingress"
}

# permit egress from instances
resource "aws_security_group_rule" "permit_app_egress" {
  from_port = 0
  to_port = 65535

  protocol = "tcp"

  security_group_id = "${aws_security_group.sg_app_subnet.id}"
  cidr_blocks = ["0.0.0.0/0"]

  type="egress"
}

