resource "openstack_compute_instance_v2" "vm" {
  count           = "${var.contador}"
  name            = "${format("%s-%d", var.tenant_name, random_id.rdid.dec + count.index)}"
  image_id        = "${lookup(var.images, "Win2012")}"
  flavor_name     = "${var.flavor}"
  key_pair        = "${var.keypair}"
  security_groups = ["${openstack_compute_secgroup_v2.sg01.name}"]
  user_data       = "${data.template_file.cloudinit.rendered}"

  network {
    uuid = "${openstack_networking_network_v2.net01.id}"
  }

  metadata = {
    CreatedFrom = "Auto deploy ${random_id.rdid.dec}"
  }
}


data "template_file" "cloudinit" {
  template = "${file("./data.txt")}"

  vars {
    NewAdminUser = "${var.MainUserAdministrator}"
    NewAdminPass = "${var.MainAdministratorPassword}"
  }
}
resource "openstack_compute_floatingip_v2" "float_ip" {
  count = "${var.contador}"
  pool  = "${var.ext_net}"
}

resource "openstack_compute_floatingip_associate_v2" "float_ip_assoc" {
  count       = "${var.contador}"
  floating_ip = "${element(openstack_compute_floatingip_v2.float_ip.*.address, count.index)}"
  instance_id = "${element(openstack_compute_instance_v2.vm.*.id, count.index)}"
}
