module "resource_group" {
    source = "./modules/rg"
    
    region              =   "${var.region}"
    resource_group_name =   "${var.resource_group_name}"
}

module "network" {
   source = "./modules/network"
   
   resource_group_name  =   module.resource_group.name
   region               =   module.resource_group.location
}

module "nfs" {
    source ="./modules/nfs"

    anf_account_name    =   "${var.anf_account_name}"
    resource_group_name =   "${var.pool_resource_group_name}"
    region              =   module.resource_group.location
    anf_pool_name       =   "${var.anf_pool_name}"
    anf_vol_name        =   "${var.anf_vol_name}"
    anf_pool_ser_lvl    =   "${var.anf_pool_ser_lvl}"
    anf_vol_size        =   "${var.anf_vol_size}"
    subnet_id           =   module.network.subnet_id
}

#module "Linux_VM" {
#
#    source="./modules/LinuxVM"
#
#}