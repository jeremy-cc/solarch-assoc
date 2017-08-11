output "alb_arn" {
  value = "${aws_alb.alb.arn}"
}

output "public_subnet_subnet_ids" {
  value = ["${aws_subnet.app.*.id}"]
}

output "launch_config_id" {
  value = "${aws_launch_configuration.lc.id}"
}