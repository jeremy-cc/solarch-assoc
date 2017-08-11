resource "aws_alb_target_group" "tg" {
  port = 80
  protocol = "HTTP"
  vpc_id = "${aws_vpc.vpc.id}"
  name = "web-tg"

  lifecycle {
    create_before_destroy = false
  }

  tags {
    Name = "solarch-alb-tg-ws"
    Env  = "solarch"
  }

  health_check {
    healthy_threshold = 2
    interval = 30
    unhealthy_threshold = 5
    port = 80
    path = "/health.html"
    protocol = "HTTP"
    timeout = 5
  }
}

resource "aws_alb" "alb" {
  subnets = ["${aws_subnet.app.*.id}"]

  security_groups = ["${aws_security_group.sg_app_subnet.id}"]

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