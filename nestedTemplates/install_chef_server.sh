#!/bin/bash

ADMIN_EMAIL=$1
ORG_SHORT_NAME=$2
ORG_LONG_NAME=$3
KEY_DIR=$4
sa_name=$5
rg_name=$6
container_name01=$7
container_name02=$8
az_user=$9
az_pass=${10}
az_tenant=${11}

rpm --import https://packages.microsoft.com/keys/microsoft.asc
sh -c 'echo -e "[azure-cli]\nname=Azure CLI\nbaseurl=https://packages.microsoft.com/yumrepos/azure-cli\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/azure-cli.repo'
yum check-update

yum install samba-client samba-common cifs-utils jq.x86_64 azure-cli -y

az login --service-principal -u $az_user -p $az_pass --tenant $az_tenant

echo "Creating the storage-account..."

az storage account create \
    --location eastus \
    --name $sa_name \
    --resource-group $rg_name \
    --sku Premium_LRS

echo "Creating the containers..."
az storage container create --name $container_name01 --account-name $sa_name
az storage container create --name $container_name02 --account-name $sa_name

current_env_conn_string = $(az storage account show-connection-string -n $sa_name -g $rg_name --query 'connectionString' -o tsv)

if [[ $current_env_conn_string == "" ]]; then  
    echo "Couldn't retrieve the connection string."
fi

az storage share create --name files --quota 2048 --connection-string $current_env_conn_string 1 > /dev/null

sa_key=$(az storage account keys list --name $sa_name --resource-group $rg_name | jq '.[0] | .value')

mkdir /chefmnt/keys

bash -c 'echo "//' + $sa_name + \
    '.file.core.windows.net/files /chefmnt cifs vers=3.0,username=' + $sa_name + \
    ',password=' + $sa_key + ',dir_mode=0777,file_mode=0777,serverino" >> /etc/fstab'

mount -a

mkdir $KEY_DIR

wget https://packages.chef.io/files/stable/chef-server/12.16.9/el/7/chef-server-core-12.16.9-1.el7.x86_64.rpm && rpm -Uvh chef-server-core-12.16.9-1.el7.x86_64.rpm && chef-server-ctl reconfigure

# create admin user
chef-server-ctl user-create delivery chef delivery $ADMIN_EMAIL '$PASSWORD' --filename $KEY_DIR/delivery.pem

# create organization
chef-server-ctl org-create $ORG_SHORT_NAME $ORG_LONG_NAME --filename $KEY_DIR/$ORG_SHORT_NAME-validator.pem -a delivery

echo "Done"