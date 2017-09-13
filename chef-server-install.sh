#!/bin/bash

ADMIN_EMAIL=$1
ORG_SHORT_NAME=$2
ORG_LONG_NAME=$3
KEY_DIR=$4

wget https://packages.chef.io/files/stable/chef-server/12.16.9/el/7/chef-server-core-12.16.9-1.el7.x86_64.rpm && sudo rpm -Uvh chef-server-core-12.16.9-1.el7.x86_64.rpm && sudo chef-server-ctl reconfigure

# create admin user
sudo chef-server-ctl user-create delivery chef delivery $ADMIN_EMAIL '$PASSWORD' --filename $KEY_DIR/delivery.pem

# create organization
sudo chef-server-ctl org-create $ORG_SHORT_NAME $ORG_LONG_NAME --filename $KEY_DIR/$ORG_SHORT_NAME-validator.pem -a delivery
