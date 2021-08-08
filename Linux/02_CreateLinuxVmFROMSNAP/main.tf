resource "openstack_compute_keypair_v2" "linux_key2" {
  name       = "linux_key2"
  public_key = "${file("./mykey.pub")}"
}

resource "openstack_compute_secgroup_v2" "linux-stack2" {
  name        = "linux-stack2"
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

resource "openstack_compute_instance_v2" "linux-stack2" {
  count = "${var.count}"
  name  = "${format(var.server, count.index+1)}"

  #image_name      = "${var.image_name}"
  flavor_name     = "${var.flavor}"
  key_pair        = "${openstack_compute_keypair_v2.linux_key2.id}"
  security_groups = ["${openstack_compute_secgroup_v2.linux-stack2.id}"]
  user_data       = "${file("cloud-init.yaml")}"

  network {
    uuid = "${var.network}"
  }

  block_device {
    uuid                  = "68121506-022d-437e-bf7d-b6675f4d320d"
    source_type           = "snapshot"
    destination_type      = "volume"
    boot_index            = 0
    delete_on_termination = true
    volume_size           = 50
  }
}

resource "openstack_compute_floatingip_v2" "linux-stack_floatip2" {
  count = "${var.count}"
  pool  = "net-ext2"
}

resource "openstack_compute_floatingip_associate_v2" "linux-stack_floatip_assoc2" {
  count       = "${var.count}"
  floating_ip = "${element(openstack_compute_floatingip_v2.linux-stack_floatip2.*.address, count.index)}"
  instance_id = "${element(openstack_compute_instance_v2.linux-stack2.*.id, count.index)}"
}
