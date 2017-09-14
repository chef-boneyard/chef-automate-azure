#!/bin/bash

vm_name=$1 #name of automate server
rg_name=$2
runner_password=$3
runner_username=$4
az_user=$5
az_pass=$6
az_tenant=$7
runner_ip=$(hostname  -I | cut -f1 -d' ')
ext_config='{
    "fileUris": ["https://raw.githubusercontent.com/chef-customers/chef-automate-azure/OrchestrationTemplate/nestedTemplates/register_automate_runner.sh"],
    "commandToExecute": "./register_automate_runner.sh ' + $runner_password $runner_ip $runner_username + '"
}'

rpm --import https://packages.microsoft.com/keys/microsoft.asc
sh -c 'echo -e "[azure-cli]\nname=Azure CLI\nbaseurl=https://packages.microsoft.com/yumrepos/azure-cli\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/azure-cli.repo'
yum check-update

yum install azure-cli -y

az login -u $az_user -p $az_pass --tenant $az_tenant

az vm extension set --resource-group $rg_name --vm-name $vm_name --name runnerScript --publisher Microsoft.Azure.Extensions --settings $ext_config