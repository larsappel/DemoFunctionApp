#!/bin/bash

# Provision the Azure resources
cd Infrastruture
./check_prerequisites.sh
./create_function_app_api_azure.sh

# Wait for the function app to be created
echo -n "Deploying the function app..."
for i in {1..12}; do
    echo -n "."
    sleep 10
done

# Deploy the function app
cd ../DemoFunction
func azure functionapp publish DemoFunc$(date +"%y%m%d")

# Test the function app
curl -w "\n" https://demofunc$(date +"%y%m%d").azurewebsites.net/api/TableDemo
