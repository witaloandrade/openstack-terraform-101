output "address" {
  value = "${openstack_compute_floatingip_v2.elk-stack_floatip.*.address}"
}