terraform {
  backend "azurerm" {}
}

data "terraform_remote_state" "shared" {
  backend = "azurerm"

  config {
    storage_account_name = "${var.k8sbook_prefix}${var.k8sbook_chap}tfstate"
    container_name       = "tfstate-shared"
    key                  = "terraform.tfstate"
  }
}

/*
provider "azurerm" {
  version = "~>1.20.0"
}
*/

module "primary" {
  source = "../modules/cluster"

  prefix                              = "${var.k8sbook_prefix}"
  chap                                = "${var.k8sbook_chap}"
  cluster_type                        = "primary"
  resource_group_name                 = "${data.terraform_remote_state.shared.resource_group_name}"
  location                            = "${data.terraform_remote_state.shared.resource_group_location}"
  traffic_manager_profile_name        = "${data.terraform_remote_state.shared.traffic_manager_profile_name}"
  traffic_manager_endpoint_priority   = 100
  cosmosdb_account_name               = "${data.terraform_remote_state.shared.cosmosdb_account_name}"
  cosmosdb_account_primary_master_key = "${data.terraform_remote_state.shared.cosmosdb_account_primary_master_key}"
}

module "failover" {
  source = "../modules/cluster"

  prefix                              = "${var.k8sbook_prefix}"
  chap                                = "${var.k8sbook_chap}"
  cluster_type                        = "failover"
  resource_group_name                 = "${data.terraform_remote_state.shared.resource_group_name}"
  location                            = "${var.k8sbook_failover_location}"
  traffic_manager_profile_name        = "${data.terraform_remote_state.shared.traffic_manager_profile_name}"
  traffic_manager_endpoint_priority   = 500
  cosmosdb_account_name               = "${data.terraform_remote_state.shared.cosmosdb_account_name}"
  cosmosdb_account_primary_master_key = "${data.terraform_remote_state.shared.cosmosdb_account_primary_master_key}"
}
