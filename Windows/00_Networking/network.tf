## Router
resource "openstack_networking_router_v2" "router" {
  name                = "Ext-Rt-Dep-${random_id.rdid.dec}"
  description         = "External Router  Deploy ${random_id.rdid.dec}"
  admin_state_up      = "true"
  external_network_id = "9544246d-56c3-4f08-a3b6-e4dd47542634"
}

## Network
resource "openstack_networking_network_v2" "net01" {
  name           = "Net01-Dep-${random_id.rdid.dec}"
  description    = "Network Deploy ${random_id.rdid.dec}"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "subnet01" {
  name            = "SubnetIpv4-Deploy-${random_id.rdid.dec}"
  description     = "Subnet ipv4 Network Deploy ${random_id.rdid.dec}"
  network_id      = "${openstack_networking_network_v2.net01.id}"
  cidr            = "192.168.0.0/24"
  ip_version      = 4
  enable_dhcp     = "true"
  dns_nameservers = ["8.8.8.8", "1.1.1.1"]
}

resource "openstack_networking_router_interface_v2" "ext-int-subnet01" {
  router_id = "${openstack_networking_router_v2.router.id}"
  subnet_id = "${openstack_networking_subnet_v2.subnet01.id}"
}
