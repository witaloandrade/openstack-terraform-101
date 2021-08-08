resource "openstack_compute_instance_v2" "vm" {
  name            = "${var.namead}"
  flavor_name     = "${var.flavorad}"
  key_pair        = "${var.keyad}"
  security_groups = ["${var.sgad}"]
  user_data       = "${data.template_file.cloudinit.rendered}"

  network {
    uuid = "${var.netad}"
  }

  block_device {
    uuid                  = "${var.snapid}"
    source_type           = "snapshot"
    destination_type      = "volume"
    boot_index            = 0
    delete_on_termination = true
    volume_size           = 50
  }

  metadata = {
    CreatedFrom = "Auto deploy ${var.id}"
  }
}

data "template_file" "cloudinit" {
  template = "${file("${path.module}/data.txt")}"

  vars {
    NewAdminUser = "${var.ADAdminUser}"
    NewAdminPass = "${var.ADAdminPass}"
  }
}

resource "template_dir" "config" {
  source_dir      = "${path.module}/Scripts"
  destination_dir = "${path.module}/ScriptsRender"

  vars {
     NewAdminUser = "${var.ADAdminUser}"
     NewAdminPass = "${var.ADAdminPass}"
     MNewComputerName = "${var.ADComputerName}"
     NewDomainName = "${var.ADDomainName}"
     NewNetBiosName = "${var.ADNetBiosName}"
     NewDomainMode = "${var.ADDomainMode}"
     NewForestMode = "${var.ADForestMode}"
  }
}

resource "openstack_compute_floatingip_v2" "float_ip" {
  pool = "${var.net_ext}"
}

resource "openstack_compute_floatingip_associate_v2" "float_ip_assoc" {
  floating_ip = "${openstack_compute_floatingip_v2.float_ip.address}"
  instance_id = "${openstack_compute_instance_v2.vm.id}"
}

resource "null_resource" "delay" {
  depends_on = ["openstack_compute_instance_v2.vm"]

  triggers = {
    server_id = "${openstack_compute_instance_v2.vm.id}"
  }

  provisioner "local-exec" {
    command = "ping 127.0.0.1 -n 300 > nul"
  }
}

resource "null_resource" "copy-files" {
  depends_on = ["null_resource.delay"]

  triggers = {
    server_id = "${openstack_compute_instance_v2.vm.id}"
  }

  connection {
    type     = "winrm"
    user     = "${var.ADAdminUser}"
    password = "${var.ADAdminPass}"
    insecure = "true"
    host     = "${openstack_compute_floatingip_v2.float_ip.address}"
  }

  provisioner "file" {
    source      = "${template_dir.config.destination_dir}"
    destination = "C://Scripts"
  }
}

resource "null_resource" "exec" {
  depends_on = ["null_resource.copy-files"]

  triggers = {
    server_id = "${openstack_compute_instance_v2.vm.id}"
  }

  connection {
    type     = "winrm"
    user     = "${var.ADAdminUser}"
    password = "${var.ADAdminPass}"
    insecure = "true"
    host     = "${openstack_compute_floatingip_v2.float_ip.address}"
  }

  provisioner "remote-exec" {
    script = "${path.module}/friday.bat"
  }
}

output "ip_ad" {
  value = "${openstack_compute_floatingip_v2.float_ip.address}"
}
output "ip_ad_local" {
  value = "${openstack_compute_instance_v2.vm.access_ip_v4}"
}
