resource "aws_launch_configuration" "bastion-lc" {
  image_id = "${var.ami_id}"

  instance_type = "${var.default_instance_type}"

  name = "solarch-bastion-launchconfig"

  security_groups = ["${aws_security_group.sg_bastion.id}"]

  user_data = "${data.template_file.template-userdata-bastion.rendered}"

  associate_public_ip_address = true

  key_name = "${var.access-key-name}"

  lifecycle {
    create_before_destroy = false
  }
}

resource "aws_autoscaling_group" "bastion-asg" {
  launch_configuration = "${aws_launch_configuration.bastion-lc.id}"

  max_size = 1
  min_size = 1

  name = "bastion-asg"

  health_check_grace_period = 300

  health_check_type = "ELB"

  vpc_zone_identifier = ["${aws_subnet.app.*.id}"]

  lifecycle {
    create_before_destroy = false
  }

  tag {
    key = "Env"
    propagate_at_launch = true
    value = "solarch"
  }

  tag {
    key = "Name"
    propagate_at_launch = true
    value = "bastion-asg"
  }

}