variable "resource_group_name" {
  type = string
  default = "dpAuto"
  description = "Personal Azure RG for network and vm resources"
}
variable "region" {
  type    = string
  default = "South Central US"
  description = "The region used for personal Azure RG, network and vm resources"
}

variable "subnet_id" {
  type = string
  default = ""
  description = "Use for the subnet ID returned during the network setup"
}

variable "pool_resource_group_name" {
  type = string
  default = "southc.rg"
  description = "Shared Azure RG for ANF storage resources"
}

variable "anf_account_name" {
  type = string
  default = "ANF-SouthCentralUS-Acct"
  description = "Shared Azure NetApp Files Account Name"
}

variable "anf_pool_name" {
  type = string
  default = "ANF-dpAutoPool"
  description = "Personal capcity pool name"
}

variable "anf_pool_ser_lvl" {
  type = string
  default = "Standard"
  description = "Capacity pool service level (Standard, Premium or Ultra)"
}

variable "anf_vol_size" {
  type = number
  default = 4
  description = "ANF volume size.  (Minimum is 4, maximum is 500)"
}

variable "anf_vol_name" {
  type = string
  default = "vol-01"
  description = "ANF volume name during deployment"
}

variable "username" {
  type    = string
  default = "dpadmin"
  description = "Domain Admin user name for Windows AD deployment"
}

variable "password" {
  type    = string
  default = "th!sp@ssword1sbad"
  description = "Domain Admin password for Windows AD deployment"
}

variable "domainname" {
  type    = string
  default = "dp.test"
  description = "Personal Windows AD Domain name"
}

variable "smbservername" {
  type    = string
  default = "anfsmb"
  description = "Personal SMB server for mounting SMB volumes"
}
