
resource "openstack_compute_secgroup_v2" "elk-stack" {
  name        = "elk-stack"
  description = "Security group para o elk-stack"

  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0/32"
  }

  rule {
    from_port   = 80
    to_port     = 80
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = -1
    to_port     = -1
    ip_protocol = "icmp"
    cidr        = "0.0.0.0/0"
  }
}

resource "openstack_compute_instance_v2" "elk-stack" {
  count           = "${var.count}"
  name            = "${format(var.server, count.index+1)}"
  image_name      = "${var.image_name}"
  flavor_name     = "${var.flavor}"
  key_pair        = "${var.keypair}"
  security_groups = ["${openstack_compute_secgroup_v2.elk-stack.name}","default"]
  user_data       = "${file("cloud-init.yaml")}"

  network {
    uuid = "${var.network}"
  }

  block_device {
    uuid                  = "${var.image_uuid}"
    source_type           = "image"
    destination_type      = "volume"
    boot_index            = 0
    delete_on_termination = true
    volume_size           = 150
  }
}

resource "openstack_compute_floatingip_v2" "elk-stack_floatip" {
  count = "${var.count}"
  pool  = "net-ext2"
}

resource "openstack_compute_floatingip_associate_v2" "elk-stack_floatip_assoc" {
  count       = "${var.count}"
  floating_ip = "${element(openstack_compute_floatingip_v2.elk-stack_floatip.*.address, count.index)}"
  instance_id = "${element(openstack_compute_instance_v2.elk-stack.*.id, count.index)}"
}