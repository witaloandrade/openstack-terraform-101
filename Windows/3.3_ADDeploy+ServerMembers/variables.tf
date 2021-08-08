## Variaveis para alteração criação de Active Directory

variable "MainUserAdministrator" {
  description = "Nome do usuário Administrador"
  default     = "Administrator"
}

variable "MainAdministratorPassword" {
  description = "Senha do Usuário Administrador"
  default     = "Y0urP4$$w0rdH3r3witalo"
}

variable "MainComputerName" {
  description = "Novo Nome do DC"
  default     = "DC01"
}

variable "MainDomainName" {
  description = "Nome de Domínio"
  default     = "narnia.local"
}

variable "MainNetBIOSName" {
  description = "Nome Net Bios"
  default     = "narnia"
}

variable "MainDomainMode" {
  description = "AD Domain Level"
  default     = "Win2012R2"
}

variable "MainForestMode" {
  description = "AD Forest Mode"
  default     = "Win2012R2"
}

## Variaveis para alteração criação de ambiente
variable "membros" {
  description = "Specify how many servers  members should be created"
  default     = "2"
}

variable "snap_uuid" {
  description = "The snapshot to be used on computer block device creations"
  default     = "8051c779-38e4-4576-a940-55ecca9ec193"
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
