// Parameters for reusable elements
param storageAccountName string             // Unique storage account name
param functionAppName string                // Unique function app name
param runtime string = 'dotnet-isolated'    // Runtime for the function app

// Resource Group is handled in the CLI, no need to define it here

// Create the Storage Account for Function App and to host the static website
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: storageAccountName
  location: resourceGroup().location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    allowBlobPublicAccess: false
  }
}

// Create a Consumption Plan for the Function App
resource hostingPlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: '${functionAppName}-plan'
  location: resourceGroup().location
  sku: {
    name: 'Y1'  // Consumption plan
    tier: 'Dynamic'
  }
}

// Create the Function App and link to the Storage Account
resource functionApp 'Microsoft.Web/sites@2022-03-01' = {
  name: functionAppName
  location: resourceGroup().location
  kind: 'functionapp'
  properties: {
    serverFarmId: resourceId('Microsoft.Web/serverfarms', '${functionAppName}-plan') // Consumption Plan
    siteConfig: {
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};AccountKey=${storageAccount.listKeys().keys[0].value}'
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: runtime
        }
      ]
    }
  }
}

// Enable CORS for the Function App (All origins allowed)
resource corsSettings 'Microsoft.Web/sites/config@2022-03-01' = {
  parent: functionApp
  name: 'web'
  properties: {
    cors: {
      allowedOrigins: [
        '*'
      ]
    }
  }
}

// Output the Function App URL
output functionAppUrl string = 'https://${functionApp.properties.defaultHostName}'
