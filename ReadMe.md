
Install the Azure Functions Core Tools
https://learn.microsoft.com/en-us/azure/azure-functions/create-first-function-cli-csharp?tabs=linux%2Cazure-cli#install-the-azure-functions-core-tools

Run this code in order to start fresh

```bash
# Create a local function project
func init --worker-runtime dotnet-isolated --target-framework net8.0

# Add a function to your project by using the following command
func new --name HttpDemo --template "HTTP trigger" --authlevel "anonymous"

# Run the function locally
func start
```

Create supporting Azure resources for your function before you deploy!

```bash
# Deploy the function project to Azure
func azure functionapp publish DemoFunc$(date +"%y%m%d")
```

```bash
#Add packages
dotnet add package Newtonsoft.Json
dotnet add package Azure.Data.Tables
```

This file shold be set in .gitignore but is included in the demo

> local.settings.json
```json
{
    "IsEncrypted": false,
    "Values": {
        "AzureWebJobsStorage": "UseDevelopmentStorage=true",
        "FUNCTIONS_WORKER_RUNTIME": "dotnet-isolated"
    }
}
```
