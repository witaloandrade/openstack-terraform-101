variable "MainUserAdministrator" {
  description = "Nome do usuário Administrador"
  default     = "Administrator"
}

variable "MainAdministratorPassword" {
  description = "Senha do Usuário Administrador"
  default     = "Y0urP4$$w0rdH3r3"
}

variable "contador" {
  description = "Specify how many servers should be created"
  default     = "1"
}

variable "image_uuid" {
 type = "map"
  default = {
    srv2012 = "f6ed9ba7-9a53-4033-87d8-947a97579846"
    srv2016 = "0d1958ed-3240-4289-b15c-7b1ae5b8d57d"
  }
}

variable "flavor" {
  description = "Specify the size of the computer"
  default     = "g1.medium"
}

variable "keypair" {
  description = "Specify the openStack key to be added to the Computer"
  default     = "defaultkey"
}
variable "ext_net" {
  description = "Specify the name of the external network to alocate public IPs"
  default     = "net-ext2"
}
