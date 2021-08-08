variable "server" {
  default = "CD123XYZ-%02d"
}

variable "image_name" {
  default = "linux-centos-7-64b-base"
}

variable "image_uuid" {
  default = "0703de9c-1438-460d-b0b2-885207dfccec"
}

variable "flavor" {
  default = "g1.medium"
}

variable "ssh_key_file" {
  default = "./mykey"
}

variable "ssh_user_name" {
  default = "centos"
}

variable "net_ext2" {
  default = "9544246d-56c3-4f08-a3b6-e4dd47542634"
}

variable "pool" {
  default = "net-ext2"
}

variable "network" {
  default = "3d49b301-ee3f-44e3-9db0-0bb0257d8902"
}

variable "keypair" {
  default = "defaultkey"
}

variable "count" {
  default = 1
}
