#!/bin/bash

AUTOMATE_LICENSE=$1
DELIVERY_KEY=$2
CHEF_SERVER_FQDN=$3
AUTOMATE_CHEF_ORG=$4
AUTOMATE_SERVER_FQDN=$5
ENTERPRISE_NAME=$6
KEY_DIR=$7

# install rpm
wget https://packages.chef.io/files/stable/automate/1.6.99/el/7/automate-1.6.99-1.el7.x86_64.rpm && sudo rpm -Uvh automate-1.6.99-1.el7.x86_64.rpm

# install automate
sudo automate-ctl setup --license $KEY_DIR/$AUTOMATE_LICENSE --key $KEY_DIR/$DELIVERY_KEY --server-url https://$CHEF_SERVER_FQDN/organizations/$AUTOMATE_CHEF_ORG --fqdn $AUTOMATE_SERVER_FQDN --enterprise $ENTERPRISE_NAME --configure
