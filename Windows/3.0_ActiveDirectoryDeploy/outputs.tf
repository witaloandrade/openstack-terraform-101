output "Public IPs From Servers" {
  value = ["${openstack_compute_floatingip_v2.float_ip.address}"]
}
