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

resource "aws_key_pair" "access-key" {
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC5nlbJX7W3c0KPtBAyYzCuxGoiHeP5wHa1zdy9sacTjIkEGdTaFf15LxVNcursC3J/vR7Rs3FEfRPwVhhkzuK+vfxgRWj46crVpoM7PvAoUScOe3JKlrT++WE6Scep0sbzNGlNnHkVsbzvqfxxMdYpz/yKPwNcimCcN5Qjid67IDFlr1u9ZztXf8pfvjAuY0QmGWBiMCYXT6XHDmoXhGZmJtFYbWp1CQ1IbXUNyE/jpLgFFrb+ogSyaq/NQjILg1YyhxE1DPh8g0FzdS5NOcvfHi3E4e3kxrK6iWaF7r1USyumAMxxefsi4ovoaNeRD5F3oZWRJpnOU4AC3ZxS5lSR jeremybotha@ldn083mac"
  key_name = "app-access-key"
}