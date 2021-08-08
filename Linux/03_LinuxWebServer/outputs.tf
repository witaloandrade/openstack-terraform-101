output "Public IPs From Servers" {
  value = ["${openstack_compute_floatingip_v2.linux-stack_floatip.*.address}"]
}
