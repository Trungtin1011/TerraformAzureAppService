#!/bin/bash
RESOURCE_GROUP_NAME=RG_Group4_week3_20220321
STORAGE_ACCOUNT_NAME=bitotfstate
CONTAINER_NAME=tfstate


# Create storage account
az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob

# Get storage account key
ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query '[0].value' -o tsv)

# Create blob container
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME --account-key $ACCOUNT_KEY

echo "storage_account_name: $STORAGE_ACCOUNT_NAME"
echo "container_name: $CONTAINER_NAME"
echo "access_key: $ACCOUNT_KEY"

# storage_account_name: bitotfstate
# container_name: tfstate
# access_key: 3GRCX3ihIRlXDhqOPJR7yMGf+6MUC3JJNWt4Y7F5dPJqy7Dg2ycuJj4rWb8EDZ0dxQdOJWYIcHSMZ0rYexoHgQ==

