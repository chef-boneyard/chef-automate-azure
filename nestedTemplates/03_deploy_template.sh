#!/bin/bash

rg=subway

az group deployment create --name vmssdeploy --resource-group subway --template-file azuredeploy.json --parameters @azuredeploy.parameters.json
