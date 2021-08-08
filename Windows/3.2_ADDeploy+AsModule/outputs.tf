
output "Public_IP_Domain_Controller" {
  value = "${module.ad.ip_ad}"
}
output "Local_IP_Domain_Controller" {
  value = "${module.ad.ip_ad_local}"
}



