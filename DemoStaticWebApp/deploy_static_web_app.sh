#!/bin/bash

# Variables
RESOURCE_GROUP="DemoRG"

TODAY=$(date +"%y%m%d") # Get current date in YYMMDD format
STORAGE_ACCOUNT_NAME="demofunc$TODAY"  # Must be unique

# Get the storage account connection string
STORAGE_ACCOUNT_CONNECTION_STRING=$(az storage account show-connection-string --name $STORAGE_ACCOUNT_NAME --resource-group $RESOURCE_GROUP --query connectionString --output tsv)

# Enabe the static website feature on the storage account
az storage blob service-properties update --account-name $STORAGE_ACCOUNT_NAME \
                                          --static-website \
                                          --index-document index.html \
                                          --404-document 404.html \
                                          --connection-string $STORAGE_ACCOUNT_CONNECTION_STRING

# Upload the static website files to the storage account
az storage blob upload-batch --account-name $STORAGE_ACCOUNT_NAME \
                             --destination '$web' \
                             --source ./web \
                             --overwrite \
                             --connection-string $STORAGE_ACCOUNT_CONNECTION_STRING

# Get the URL for the static website
STATIC_WEBSITE_URL=$(az storage account show --name $STORAGE_ACCOUNT_NAME --resource-group $RESOURCE_GROUP --query "primaryEndpoints.web" --output tsv)

echo "Static website URL: $STATIC_WEBSITE_URL"