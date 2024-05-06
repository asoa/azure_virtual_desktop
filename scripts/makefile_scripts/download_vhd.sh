#!/usr/bin/env bash

source .env

source="/subscriptions/${subscription_id}/resourceGroups/${image_gallery_rg}/providers/Microsoft.Compute/galleries/${image_gallery_name}/images/${image_definition_name}/versions/${image_version}"

az disk create --resource-group $image_gallery_rg --location EastUS --name $disk_name --gallery-image-reference $source

az disk update --name $disk_name --resource-group $image_gallery_rg --data-access-auth-mode AzureActiveDirectory

sas_uri=$(az disk grant-access --duration-in-seconds 3600 --access-level Read --name $disk_name --resource-group $image_gallery_rg | jq -r '.accessSas')

az storage blob download -f $localFolder --blob-url $sas_uri --auth-mode login