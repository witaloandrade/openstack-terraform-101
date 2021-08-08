resource "openstack_compute_instance_v2" "SRVMember" {
  count = "${var.contador}"
  name            = "${format("%s-%d", var.tenant, var.id + count.index)}"
  #name  = "${format("${var.namesrv}","${random_id.name.dec}" + count.index)}"
  #name  = "${format("${random_id.name.dec}" + count.index)}"
  #name            = "${var.namesrv}"
  flavor_name     = "${var.flavorsrv}"
  key_pair        = "${var.keysrv}"
  security_groups = ["${var.sgsrv}"]
   user_data       = "${data.template_file.cloudinit.rendered}"

  network {
    uuid = "${var.netsrv}"
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
  source_dir = "${path.module}/Scripts"
  destination_dir = "${path.module}/ScriptsRender"
  vars = {
    NewAdminUser = "${var.ADAdminUser}"
    NewAdminPass = "${var.ADAdminPass}"
    NewDomainName = "${var.ADDomainName}"
    ipad = "${var.ipad}"
  }
}

resource "openstack_compute_floatingip_v2" "srv_floatip" {
  count = "${var.contador}"
  pool = "${var.net_ext}"
}
resource "openstack_compute_floatingip_associate_v2" "srv_floatip_assoc" {
  count = "${var.contador}"
  floating_ip = "${element(openstack_compute_floatingip_v2.srv_floatip.*.address, count.index)}"
  instance_id = "${(element(openstack_compute_instance_v2.SRVMember.*.id, count.index))}"
}

resource "null_resource" "delay" {
  depends_on = ["openstack_compute_instance_v2.SRVMember"]
  provisioner "local-exec" {
    command = "ping 127.0.0.1 -n 300 > nul"
  }
}
resource "null_resource" "copy-files" {
  count = "${var.contador}"
  depends_on = ["null_resource.delay"]
  connection {
    type = "winrm"
    user = "${var.ADAdminUser}"
    password = "${var.ADAdminPass}"
    insecure = "true"
    host = "${element(openstack_compute_floatingip_v2.srv_floatip.*.address, count.index)}"
  }
  provisioner "file" {
    source = "${template_dir.config.destination_dir}"
    destination = "C://Scripts"
  }
  provisioner "remote-exec" {
    script = "${path.module}/friday.bat"
  }
}

output "ip_srv" {
  value = "${openstack_compute_floatingip_v2.srv_floatip.*.address}"
}