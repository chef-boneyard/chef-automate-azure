#!/bin/bash

USER_NAME=$1
FIRST_NAME=$2
LAST_NAME=$3
EMAIL=$4
ORG_SHORT_NAME=$5
ORG_LONG_NAME=$6
KEY_DIR=$7

wget https://packages.chef.io/files/stable/chef-server/12.16.9/el/7/chef-server-core-12.16.9-1.el7.x86_64.rpm && sudo rpm -Uvh chef-server-core-12.16.9-1.el7.x86_64.rpm && sudo chef-server-ctl reconfigure

# create admin user
chef-server-ctl user-create $USER_NAME $FIRST_NAME $LAST_NAME $EMAIL 'PASSWORD' --filename $KEY_DIR/$USER_NAME.pem

# create organization
chef-server-ctl org-create $ORG_SHORT_NAME $ORG_LONG_NAME --association_user $USER_NAME --filename $KEY_DIR/$ORG_SHORT_NAME-validator.pem
