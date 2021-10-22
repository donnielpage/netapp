variable "resource_group_name" {
  default = "dpAuto"
}
variable "region" {
  type    = string
  default = "South Central US"
}

variable "subnet_id" {
  
  type = string
  default = ""
}
variable "pool_resource_group_name" {
  type = string
  default = "southc.rg"
  description = "Shared Azure RG for ANF storage resources"
}

variable "anf_account_name" {
  type = string
  default = "ANF-SouthCentralUS-Acct"
}
variable "anf_pool_name" {
  type = string
  default = "ANF-dpAutoPool"
}

variable "anf_vol_name" {
  type = string
  default = "vol-01"
}

variable "anf_pool_ser_lvl" {
  type = string
  default = "Standard"
}

variable "anf_vol_size" {
  type = number
  default = 4
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
