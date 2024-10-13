#!/bin/bash

# Verify that all necessary tools are installed and that the user is logged in to Azure CLI.

# Ensure Azure CLI is installed
if ! command -v az &> /dev/null
then
    echo "Azure CLI not found. Please install it before running this script."
    exit 1
fi

# Ensure Azure Functions Core Tools are installed
if ! command -v func &> /dev/null
then
    echo "Azure Functions Core Tools not found. Please install it before running this script."
    exit 1
fi

# Ensure .NET Core SDK is installed
if ! command -v dotnet &> /dev/null
then
    echo ".NET Core SDK not found. Please install it before running this script."
    exit 1
fi

# Check if Azure CLI is logged in
az account show > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Please log in to Azure CLI using 'az login'."
    exit 1
fi

# Output a table of installed versions of the Azure CLI, Azure Functions Core Tools, and .NET Core SDK
echo -e "\n"
echo "********************************"
echo "Azure CLI version:"
az --version | grep "azure-cli" | awk '{print $2}'
echo "--------------------------------"
echo "Azure Functions Core Tools version:"
func --version
echo "--------------------------------"
echo ".NET Core SDK version:"
dotnet --version
echo "********************************"
echo -e "\n"
echo "********************************"
echo "All prerequisites are met."
echo "********************************"
echo -e "\n"