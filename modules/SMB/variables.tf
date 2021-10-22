variable "resource_group_name" {
  default = "dpAuto"
}
variable "region" {
  type    = string
  default = "South Central US"
}

variable "username" {
  type    = string
  default = "dpadmin"
}
variable "password" {
  type    = string
  default = "F1r3cr@ck3r"
}

variable "domainname" {
  type    = string
  default = "dp.test"
}

variable "smbservername" {
  type    = string
  default = "anfsmb"
}
