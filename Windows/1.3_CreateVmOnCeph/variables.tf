variable "images" {
  type = "map"

  default = {
    Win2008 = "221367c5-1751-46b9-8a53-266f6f2af3f9"
    Win2012 = "fdca7131-3179-4fe1-9415-7d355079341d"
    Win2016 = "80cc7300-ccab-4e4a-90b6-4e72422baa65"
  }
}

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

variable "flavor" {
  description = "Specify the size of the computer"
  default     = "teste-wit"
}

variable "keypair" {
  description = "Specify the openStack key to be added to the Computer"
  default     = "defaultkey"
}
variable "ext_net" {
  description = "Specify the name of the external network to alocate public IPs"
  default     = "net-ext2"
}
