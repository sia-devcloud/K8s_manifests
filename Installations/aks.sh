#!/bin/bash
export RANDOM_ID="$(openssl rand -hex 3)"
export MY_RESOURCE_GROUP_NAME="myAKSResourceGroup$RANDOM_ID"
export REGION="eastus"
export MY_AKS_CLUSTER_NAME="myAKSCluster$RANDOM_ID"
export MY_DNS_LABEL="ltdevops$RANDOM_ID"
az group create --name $MY_RESOURCE_GROUP_NAME --location $REGION
az aks create \
    --resource-group $MY_RESOURCE_GROUP_NAME \
        --name $MY_AKS_CLUSTER_NAME \
            --node-count 2 \
                --node-vm-size 'Standard_B2s
az aks get-credentials --resource-group $MY_RESOURCE_GROUP_NAME --name$MY_AKS_CLUSTER_NAME