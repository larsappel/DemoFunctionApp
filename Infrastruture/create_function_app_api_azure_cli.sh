#!/bin/bash

# Variables
RESOURCE_GROUP="DemoRG"
LOCATION="northeurope"  # Change to your preferred Azure region

TODAY=$(date +"%y%m%d") # Get current date in YYMMDD format
STORAGE_ACCOUNT_NAME="demofunc$TODAY"  # Must be unique
FUNCTION_APP_NAME="DemoFunc$TODAY"  # Must be unique
RUNTIME="dotnet-isolated"
FUNCTION_NAME="register"

API_KEY="campusmolndal"

# Follow tutorial to create function app in Azure
# https://learn.microsoft.com/en-us/azure/azure-functions/create-first-function-cli-csharp?tabs=macos%2Cazure-cli#create-supporting-azure-resources-for-your-function

# Create Resource Group
echo "Creating Resource Group: $RESOURCE_GROUP..."
az group create --name $RESOURCE_GROUP --location $LOCATION

# Create Storage Account for Function App
echo "Creating Storage Account: $STORAGE_ACCOUNT_NAME..."
az storage account create --name $STORAGE_ACCOUNT_NAME --location $LOCATION \
                          --resource-group $RESOURCE_GROUP \
                          --sku Standard_LRS \
                          --allow-blob-public-access false

# Create Function App and link to Storage Account
echo "Creating Function App: $FUNCTION_APP_NAME..."
az functionapp create --name $FUNCTION_APP_NAME \
                      --resource-group $RESOURCE_GROUP \
                      --consumption-plan-location $LOCATION\
                      --runtime $RUNTIME \
                      --functions-version 4 \
                      --storage-account $STORAGE_ACCOUNT_NAME

# Enable CORS for Function App
echo "Enabling CORS for Function App..."
az functionapp cors add --name $FUNCTION_APP_NAME \
                        --resource-group $RESOURCE_GROUP \
                        --allowed-origins "*"

# Create function API key
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