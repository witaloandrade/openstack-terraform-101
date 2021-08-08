variable "contador" {
  description = "Specify how many servers should be created"
  default     = "1"
}

variable "image_name" {
  default = "linux-centos-7-64b-base"
}

variable "image_uuid" {
  default = "0703de9c-1438-460d-b0b2-885207dfccec"
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

variable "external_nameserver" {
  default = "8.8.8.8"
}

variable "extra_packages" {
  description = "Additional Packages to install"
  default     = "wget bind-utils httpd htop"
}

resource "random_shuffle" "elemento" {
  input        = ["Água", "Fogo", "Ar", "Terra"]
  result_count = 1
}
