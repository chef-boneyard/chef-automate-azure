#!/bin/bash

vm_name=$1 #name of automate server
rg_name=$2
runner_password=$3
runner_username=$4
runner_ip=$(hostname  -I | cut -f1 -d' ')
ext_config='{
    "fileUris": ["http://raw.github.com/path/to/register_automate_runner.sh"],
    "commandToExecute": "./register_automate_runner.sh ' + $runner_password $runner_ip $runner_username + '"
}'

az vm extension set --resource-group $rg_name --vm-name $vm_name --name runnerScript --publisher Microsoft.Azure.Extensions --settings $ext_config
