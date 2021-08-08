module "ad" {
  source = "./modules/ad"
  #Parameters To Build Domain Controler
  namead = "${format("%s-%s", var.tenant_name, "${random_id.rdid.dec}")}"
  flavorad = "${var.flavor}"
  keyad = "${var.keypair}"
  sgad = "${openstack_compute_secgroup_v2.sg01.id}"
  netad = "${openstack_networking_network_v2.net01.id}"
  net_ext = "${var.ext_net}"
  snapid = "${var.snap_uuid}"
  id = "${random_id.rdid.dec}"
  #To Build AD
  ADAdminUser = "${var.MainUserAdministrator}"
  ADAdminPass = "${var.MainAdministratorPassword}"
  ADComputerName = "${var.MainComputerName}"
  ADDomainName = "${var.MainDomainName}"
  ADNetBiosName = "${var.MainNetBIOSName}"
  ADDomainMode = "${var.MainDomainMode}"
  ADForestMode = "${var.MainForestMode}"
}

module "srvmember" {
  source = "./modules/srvmember"
  ##Parameters To Build Server Member
  #namesrv = "${format("%s-%s", var.tenant_name, "${random_id.rdidsrv.dec}")}"
  tenant = "${var.tenant_name}"
  id = "${random_id.rdidsrv.dec}"
  flavorsrv = "${var.flavor}"
  keysrv = "${var.keypair}"
  sgsrv = "${openstack_compute_secgroup_v2.sg01.id}"
  netsrv = "${openstack_networking_network_v2.net01.id}"
  net_ext = "${var.ext_net}"
  snapid = "${var.snap_uuid}"
  #To Join AD
  contador = "${var.membros}"
  ipad = "${module.ad.ip_ad_local}"
  ADAdminUser = "${var.MainUserAdministrator}"
  ADAdminPass = "${var.MainAdministratorPassword}"
  ADDomainName = "${var.MainDomainName}"
}