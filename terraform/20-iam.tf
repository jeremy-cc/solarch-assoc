data "template_file" "aws_app_policy_template" {

  template = "${file("./policies/app_policy.json")}"
}

resource "aws_iam_policy" "app_policy" {
  name = "solarch-app-policy"
  policy = "${data.template_file.aws_app_policy_template.rendered}"
}