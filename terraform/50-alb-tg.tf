resource "aws_alb_target_group" "tg" {
  port = 80
  protocol = "HTTP"
  vpc_id = "${aws_vpc.vpc.id}"

  lifecycle {
    create_before_destroy = false
  }

  tags {
    Name = "solarch-alb-tg-ws"
    Env  = "solarch"
  }

  health_check {
    healthy_threshold = 2
    interval = 10
    unhealthy_threshold = 2
    port = "80"
    protocol = "HTTP"
    timeout = 5
  }
}

resource "aws_alb" "alb" {
  subnets = ["${aws_subnet.public.*.id}"]

  security_groups = ["${aws_security_group.sg_public_subnet.id}"]

  name = "web-alb"

  lifecycle {
    create_before_destroy = true
  }

  tags {
    Name = "solarch-alb-ws"
    Env = "solarch"
  }


}

resource "aws_alb_listener" "alb-listener"{
  load_balancer_arn = "${aws_alb.alb.arn}"

  port = 80
  protocol = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.tg.arn}"
    type = "forward"
  }

  lifecycle {
    create_before_destroy = true
  }

}