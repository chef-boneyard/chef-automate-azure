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

current_env_conn_string = $(az storage account show-connection-string -n $sa_name -g $rg_name --query 'connectionString' -o tsv)

if [[ $current_env_conn_string == "" ]]; then  
    echo "Couldn't retrieve the connection string."
fi

az storage share create --name files --quota 2048 --connection-string $current_env_conn_string 1 > /dev/null

sudo yum install samba-client samba-common cifs-utils jq.x86_64

sa_key=$(az storage account keys list --name $sa_name --resource-group $rg_name | jq '.[0] | .value')

mkdir mymountpoint
sudo bash -c 'echo "//' + $sa_name + \
    '.file.core.windows.net/files /mymountpoint cifs vers=3.0,username=' + $sa_name + \
    ',password=' + $sa_key + ',dir_mode=0777,file_mode=0777,serverino" >> /etc/fstab'

sudo mount -a

echo "Done"
