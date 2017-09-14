#!/bin/bash

rg=subway

az group deployment create --name vmssdeploy1 --resource-group chefsubway --template-file azuredeploy.json --parameters @azuredeploy.parameters.json
