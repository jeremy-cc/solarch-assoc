data "template_file" "aws_assume_role_template" {
  template = "${file("./policies/app_assume_role.json")}"
}

data "template_file" "aws_app_policy_template" {

  template = "${file("./policies/app_policy.json")}"
}

resource "aws_iam_role" "assume_policy_role" {
  name = "solarch-app-assume-policy-role"
  assume_role_policy = "${data.template_file.aws_assume_role_template.rendered}"
}

resource "aws_iam_role_policy" "app_policy" {
  name = "solarch-app-policy"
  role = "${aws_iam_role.assume_policy_role.name}"
  policy = "${data.template_file.aws_app_policy_template.rendered}"
}

resource "aws_iam_instance_profile" "app_instance_profile" {
  name = "solarch-app-instance-profile"
  role = "${aws_iam_role.assume_policy_role.name}"
}
