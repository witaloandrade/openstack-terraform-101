output "SubnetIpv4" {
  value = "${openstack_networking_subnet_v2.SubnetIpv4.cidr}"
}
output "Ipv4Gateway" {
  value = "${openstack_networking_subnet_v2.SubnetIpv4.gateway_ip}"
}

output "SubnetIpv6" {
  value = "${openstack_networking_subnet_v2.SubnetIpv6.cidr}"
}