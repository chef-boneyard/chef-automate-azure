#!/bin/bash

AUTOMATE_LICENSE=$1
DELIVERY_KEY=$2
CHEF_SERVER_FQDN=$3
AUTOMATE_CHEF_ORG=$4
AUTOMATE_SERVER_FQDN=$5
ENTERPRISE_NAME=$6
KEY_DIR=$7
sa_name=$8
rg_name=$9

sudo yum install samba-client samba-common cifs-utils jq.x86_64

sa_key=$(az storage account keys list --name $sa_name --resource-group $rg_name | jq '.[0] | .value')

mkdir /chefmnt
sudo bash -c 'echo "//' + $sa_name + \
    '.file.core.windows.net/files /chefmnt cifs vers=3.0,username=' + $sa_name + \
    ',password=' + $sa_key + ',dir_mode=0777,file_mode=0777,serverino" >> /etc/fstab'

sudo mount -a

cd $KEY_DIR

wget https://sdadevops.blob.core.windows.net/keys/delivery.license?st=2017-09-14T17%3A27%3A00Z&se=2017-09-15T17%3A27%3A00Z&sp=rl&sv=2016-05-31&sr=b&sig=5PFB3YqG4LsdhO8QK8ao7h9PAYJ9c9mTmVlRIcX1iXY%3D

# install rpm
wget https://packages.chef.io/files/stable/automate/1.6.99/el/7/automate-1.6.99-1.el7.x86_64.rpm && sudo rpm -Uvh automate-1.6.99-1.el7.x86_64.rpm

# install automate
sudo automate-ctl setup --license $KEY_DIR/$AUTOMATE_LICENSE --key $KEY_DIR/$DELIVERY_KEY --server-url https://$CHEF_SERVER_FQDN/organizations/$AUTOMATE_CHEF_ORG --fqdn $AUTOMATE_SERVER_FQDN --enterprise $ENTERPRISE_NAME --configure
