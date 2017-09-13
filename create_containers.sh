#!/bin/bash
echo "Creating the storage-account..."
sa_name=sda01pchefrsessms01
rg_name=AZ-Chef-01
container_name01=chefserver01
container_name02=chefautomate01
az storage account create \
    --location eastus \
    --name $sa_name \
    --resource-group $rg_name \
    --sku Premium_LRS
echo "Creating the containers..."
az storage container create --name $container_name01 --name $sa_name --resource-group $rg_name
az storage container create --name $container_name02 --name $sa_name --resource-group $rg_name
echo "Done"
