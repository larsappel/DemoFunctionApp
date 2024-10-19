#!/bin/bash

# Variables
RESOURCE_GROUP="DemoRG"
LOCATION="northeurope"  # Change to your preferred Azure region

TODAY=$(date +"%y%m%d") # Get current date in YYMMDD format
STORAGE_ACCOUNT_NAME="demofunc$TODAY"  # Must be unique
FUNCTION_APP_NAME="DemoFunc$TODAY"  # Must be unique

API_KEY="campusmolndal"

# Follow tutorial to create function app in Azure
# https://learn.microsoft.com/en-us/azure/azure-functions/create-first-function-cli-csharp?tabs=macos%2Cazure-cli#create-supporting-azure-resources-for-your-function

# Create Resource Group
echo "Creating Resource Group: $RESOURCE_GROUP..."
az group create --name $RESOURCE_GROUP --location $LOCATION

# Create Storage Account for Function App
echo "Creating Bicep ..."
az deployment group create --resource-group $RESOURCE_GROUP \
                           --template-file main.bicep \
                           --parameters storageAccountName=$STORAGE_ACCOUNT_NAME \
                                        functionAppName=$FUNCTION_APP_NAME

# Create function API key
echo "Creating Function API Key ..."
az functionapp keys set --name $FUNCTION_APP_NAME \
                        --resource-group $RESOURCE_GROUP \
                        --key-name hostKey \
                        --key-type functionKeys \
                        --key-value $API_KEY

# Wait until the Function App is running
function wait_until_functionapp_is_running {
    STATUS=$(az functionapp show --name $FUNCTION_APP_NAME --resource-group $RESOURCE_GROUP --query "state" --output tsv)

    while [[ "$STATUS" != "Running" ]]; do
        echo "Waiting for Function App: $FUNCTION_APP_NAME to be ready (Current status: $STATUS)..."
        sleep 10  # Wait for 10 seconds before checking again
        STATUS=$(az functionapp show --name $FUNCTION_APP_NAME --resource-group $RESOURCE_GROUP --query "state" --output tsv)
    done

    echo "Function App: $FUNCTION_APP_NAME is now running!"
}

wait_until_functionapp_is_running