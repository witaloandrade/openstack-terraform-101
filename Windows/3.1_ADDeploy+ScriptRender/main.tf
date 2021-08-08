resource "openstack_compute_instance_v2" "vm" {
  name            = "${format("%s-%s", var.tenant_name, "${random_id.rdid.dec}")}"
  flavor_name     = "${var.flavor}"
  key_pair        = "${var.keypair}"
  security_groups = ["${openstack_compute_secgroup_v2.sg01.name}"]
  user_data       = "${data.template_file.cloudinit.rendered}"

  network {
    uuid = "${openstack_networking_network_v2.net01.id}"
  }

  block_device {
    uuid                  = "${var.snap_uuid}"
    source_type           = "snapshot"
    destination_type      = "volume"
    boot_index            = 0
    delete_on_termination = true
    volume_size           = 50
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

resource "template_dir" "config" {
  source_dir      = "Scripts"
  destination_dir = "ScriptsRender"

  vars {
    NewAdminUser     = "${var.MainUserAdministrator}"
    NewAdminPass     = "${var.MainAdministratorPassword}"
    MNewComputerName = "${var.MainComputerName}"
    NewDomainName    = "${var.MainDomainName}"
    NewNetBiosName   = "${var.MainNetBIOSName}"
    NewDomainMode    = "${var.MainDomainMode}"
    NewForestMode    = "${var.MainForestMode}"
  }
}

resource "openstack_compute_floatingip_v2" "float_ip" {
  pool = "${var.ext_net}"
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
    user     = "${var.MainUserAdministrator}"
    password = "${var.MainAdministratorPassword}"
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
    user     = "${var.MainUserAdministrator}"
    password = "${var.MainAdministratorPassword}"
    insecure = "true"
    host     = "${openstack_compute_floatingip_v2.float_ip.address}"
  }

  provisioner "remote-exec" {
    script = "friday.bat"
  }
}
