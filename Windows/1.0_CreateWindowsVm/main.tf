resource "openstack_compute_instance_v2" "vm" {
  count           = "${var.contador}"
  name            = "${format("%s-%d", var.tenant_name, random_id.rdid.dec + count.index)}"
  flavor_name     = "${var.flavor}"
  key_pair        = "${var.keypair}"
  security_groups = ["${openstack_compute_secgroup_v2.sg01.name}"]

  network {
    uuid = "${openstack_networking_network_v2.net01.id}"
  }

  block_device {
    uuid                  = "${lookup(var.image_uuid, "srv2012")}"
    #uuid                  = "${var.image_uuid}"
    source_type           = "image"
    destination_type      = "volume"
    boot_index            = 0
    delete_on_termination = true
    volume_size           = 50
  }

  metadata = {
    CreatedFrom = "Auto deploy ${random_id.rdid.dec}"
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
