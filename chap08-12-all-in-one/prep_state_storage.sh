#!/bin/bash

RESOURCE_GROUP_NAME=${TF_VAR_k8sbook_prefix}-k8sbook-tfstate-rg
STORAGE_ACCOUNT_NAME=${TF_VAR_k8sbook_prefix}tfstate
CONTAINER_NAME_SHARED=tfstate-shared
CONTAINER_NAME_CLUSTER_BLUE=tfstate-cls-blue
CONTAINER_NAME_MISC_BLUE=tfstate-misc-blue

az group create --name $RESOURCE_GROUP_NAME --location japaneast

az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob

export ARM_ACCESS_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query [0].value -o tsv)

az storage container create --name ${CONTAINER_NAME_SHARED} --account-name $STORAGE_ACCOUNT_NAME --account-key $ARM_ACCESS_KEY
az storage container create --name ${CONTAINER_NAME_CLUSTER_BLUE} --account-name $STORAGE_ACCOUNT_NAME --account-key $ARM_ACCESS_KEY
az storage container create --name ${CONTAINER_NAME_MISC_BLUE} --account-name $STORAGE_ACCOUNT_NAME --account-key $ARM_ACCESS_KEY

echo "storage_account_name: $STORAGE_ACCOUNT_NAME"
echo "container_name_shared: $CONTAINER_NAME_SHARED"
echo "container_name_cluster_blue: $CONTAINER_NAME_CLUSTER_BLUE"
echo "container_name_misc_blue: $CONTAINER_NAME_MISC_BLUE"