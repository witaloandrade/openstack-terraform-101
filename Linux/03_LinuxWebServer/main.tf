resource "openstack_compute_instance_v2" "linux-stack" {
  count           = "${var.contador}"
  name            = "${format("%s-%d", var.tenant_name, random_id.rdid.dec + count.index)}"
  image_name      = "${var.image_name}"
  flavor_name     = "${var.flavor}"
  key_pair        = "${var.keypair}"
  security_groups = ["${openstack_compute_secgroup_v2.sg01.name}"]
  user_data       = "${data.template_file.cloudinit.rendered}"

  network {
    uuid = "${openstack_networking_network_v2.net01.id}"
  }

  block_device {
    uuid                  = "${var.image_uuid}"
    source_type           = "image"
    destination_type      = "volume"
    boot_index            = 0
    delete_on_termination = true
    volume_size           = 50
  }
}

data "template_file" "cloudinit" {
  template = "${file("./user_data_sh.tpl")}"

  vars {
    packages   = "${var.extra_packages}"
    nameserver = "${var.external_nameserver}"
    id         = "${random_id.rdid.dec}"
    elemento   = "${random_shuffle.elemento.result[0]}"
  }
}

resource "openstack_compute_floatingip_v2" "linux-stack_floatip" {
  count = "${var.contador}"
  pool  = "net-ext2"
}

resource "openstack_compute_floatingip_associate_v2" "linux-stack_floatip_assoc" {
  count       = "${var.contador}"
  floating_ip = "${element(openstack_compute_floatingip_v2.linux-stack_floatip.*.address, count.index)}"
  instance_id = "${element(openstack_compute_instance_v2.linux-stack.*.id, count.index)}"
}
