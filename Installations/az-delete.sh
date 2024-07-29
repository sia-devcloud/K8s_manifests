#!/bin/bash
resource_groups=$(az group list --query '[].name' -o tsv)

if [ -z "$resource_groups" ]; then
  echo "No resource groups found."
else
  # Loop through each resource group and delete it
  for rg in $resource_groups; do
    echo "Deleting resource group: $rg"
    az group delete --name "$rg" --yes --no-wait
  done
fi

echo "Deletion of resource groups initiated."