resource "openstack_compute_keypair_v2" "linux_key" {
  name       = "linux_key"
  public_key = "${file("./mykey.pub")}"
}

resource "openstack_compute_secgroup_v2" "linux-stack" {
  name        = "linux-stack"
  description = "Security group para o linux-stack"

  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
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

resource "openstack_compute_instance_v2" "linux-stack" {
  count           = "${var.count}"
  name            = "${format(var.server, count.index+1)}"
  image_name      = "${var.image_name}"
  flavor_name     = "${var.flavor}"
  key_pair        = "${openstack_compute_keypair_v2.linux_key.id}"
  security_groups = ["${openstack_compute_secgroup_v2.linux-stack.id}"]
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
    volume_size           = 50
  }
}

resource "openstack_compute_floatingip_v2" "linux-stack_floatip" {
  count = "${var.count}"
  pool  = "net-ext2"
}

resource "openstack_compute_floatingip_associate_v2" "linux-stack_floatip_assoc" {
  count       = "${var.count}"
  floating_ip = "${element(openstack_compute_floatingip_v2.linux-stack_floatip.*.address, count.index)}"
  instance_id = "${element(openstack_compute_instance_v2.linux-stack.*.id, count.index)}"
}
