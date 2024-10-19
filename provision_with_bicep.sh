#!/bin/bash

# Provision the Azure resources
cd Infrastruture
./check_prerequisites.sh
./create_function_app_api_azure_bicep.sh

# Deploy the function app
cd ../DemoFunction
func azure functionapp publish DemoFunc$(date +"%y%m%d")

# Deploy the static website
cd ../DemoStaticWebApp
./create_javascript_app.sh
./deploy_static_web_app.sh
rm -rf ./web
