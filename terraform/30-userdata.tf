data "template_file" "template-userdata-ws" {
  template = "${file("./userdata/userdata_ws")}"
}

data "template_file" "template-userdata-bastion" {
  template = "${file("./userdata/userdata_bastion")}"
}
