provider "openstack" {
  user_name   = "${var.user_name}"
  tenant_name = "${var.tenant_name}"
  password    = "${var.password}"
  auth_url    = "${var.provurl}"
}

variable "password" {}
variable "user_name" {}
variable "tenant_name" {}
variable "provurl" {}
