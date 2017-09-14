#!/bin/bash

rg=subway

#az group deployment validate --resource-group $rg --template-file scaleset.json --parameters @scaleset.params.json
az group deployment validate --resource-group subway --template-file azuredeploy.json --parameters @azuredeploy.parameters.json
