## Create Router
resource "openstack_networking_router_v2" "router" {
  name                = "Router-Deploy-${random_id.rdid.dec}"
  description         = "External Router  Deploy ${random_id.rdid.dec}"
  admin_state_up      = "true"
  external_network_id = "9544246d-56c3-4f08-a3b6-e4dd47542634"
}

## Create Network 
resource "openstack_networking_network_v2" "network" {
  name           = "Network-Deploy-${random_id.rdid.dec}"
  description    = "Network Deploy ${random_id.rdid.dec}"
  admin_state_up = "true"
}

## Create Subnet IPv4
resource "openstack_networking_subnet_v2" "SubnetIpv4" {
  name            = "SubnetIpv4-Deploy-${random_id.rdid.dec}"
  description     = "Subnet Ipv4 Network Deploy ${random_id.rdid.dec}"
  network_id      = "${openstack_networking_network_v2.network.id}"
  subnetpool_id   = "684aa747-e842-48e9-af2a-f86eff523665"
  ip_version      = 4
  enable_dhcp     = "true"
  dns_nameservers = ["187.191.112.30"]
}

## Create Subnet IPv6
resource "openstack_networking_subnet_v2" "SubnetIpv6" {
  name              = "SubnetIpv6-Deploy-${random_id.rdid.dec}"
  description       = "Subnet Ipv6 Deploy ${random_id.rdid.dec}"
  network_id        = "${openstack_networking_network_v2.network.id}"
  subnetpool_id     = "77f5924a-5058-4a5f-9a02-91d04ab131ce"
  ip_version        = 6
  ipv6_address_mode = "dhcpv6-stateless"
  ipv6_ra_mode      = "dhcpv6-stateless"
  enable_dhcp       = "true"
  dns_nameservers   = ["2001:4860:4860::8888", "2001:4860:4860::8844"]
}

## Attach IPv4 Interface to Router
resource "openstack_networking_router_interface_v2" "int-SubnetIpv4" {
  router_id = "${openstack_networking_router_v2.router.id}"
  subnet_id = "${openstack_networking_subnet_v2.SubnetIpv4.id}"
}

## Attach IPv6 Interface to Router
resource "openstack_networking_router_interface_v2" "int-SubnetIpv6" {
  router_id = "${openstack_networking_router_v2.router.id}"
  subnet_id = "${openstack_networking_subnet_v2.SubnetIpv6.id}"
}
