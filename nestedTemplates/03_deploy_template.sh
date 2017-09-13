#!/bin/bash

rg=subway

az group deployment create --name vmssdeploy --resource-group $rg --template-file scaleset.json --parameters @scaleset.params.json
