#!/bin/bash

AUTOMATE_LICENSE=delivery.license
CHEF_SERVER_FQDN=$2
AUTOMATE_CHEF_ORG=$3
AUTOMATE_SERVER_FQDN=$4
ENTERPRISE_NAME=$5
KEY_DIR=$6
sa_name=$7
rg_name=$8
az_spn_user=$9
az_spn_sec=${10}
az_spn_ten=${11}

rpm --import https://packages.microsoft.com/keys/microsoft.asc
sh -c 'echo -e "[azure-cli]\nname=Azure CLI\nbaseurl=https://packages.microsoft.com/yumrepos/azure-cli\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/azure-cli.repo'
yum check-update

yum install samba-client samba-common cifs-utils jq.x86_64 azure-cli -y

az login -u $az_spn_user -p $az_spn_sec --tenant $az_spn_ten

sa_key=$(az storage account keys list --name $sa_name --resource-group $rg_name | jq '.[0] | .value')

mkdir /chefmnt
bash -c 'echo "//' + $sa_name + \
    '.file.core.windows.net/files /chefmnt cifs vers=3.0,username=' + $sa_name + \
    ',password=' + $sa_key + ',dir_mode=0777,file_mode=0777,serverino" >> /etc/fstab'

mount -a

cd $KEY_DIR

wget https://sdadevops.blob.core.windows.net/keys/delivery.license?st=2017-09-14T17%3A27%3A00Z&se=2017-09-15T17%3A27%3A00Z&sp=rl&sv=2016-05-31&sr=b&sig=5PFB3YqG4LsdhO8QK8ao7h9PAYJ9c9mTmVlRIcX1iXY%3D

# install rpm
wget https://packages.chef.io/files/stable/automate/1.6.99/el/7/automate-1.6.99-1.el7.x86_64.rpm && rpm -Uvh automate-1.6.99-1.el7.x86_64.rpm

# install automate
automate-ctl setup --license $KEY_DIR/$AUTOMATE_LICENSE --key $KEY_DIR/delivery.pem --server-url https://$CHEF_SERVER_FQDN/organizations/$AUTOMATE_CHEF_ORG --fqdn $AUTOMATE_SERVER_FQDN --enterprise $ENTERPRISE_NAME --configure