#Used to Connect On OpenStack API
variable "password" {}
#Used to Connect On OpenStack API
variable "user_name" {}
#Used to Connect On OpenStack API
variable "tenant_name" {}
#Randon ID To Define Resources
resource "random_id" "rdid" {
  byte_length = "2"
}
