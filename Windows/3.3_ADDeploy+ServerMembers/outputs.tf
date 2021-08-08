
output "Public_IP_Domain_Controller" {
  value = "${module.ad.ip_ad}"
}
output "Local_IP_Domain_Controller" {
  value = "${module.ad.ip_ad_local}"
}


output "Local_Server_Members" {
  value = "${module.srvmember.ip_srv}"
}