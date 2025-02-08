param functionAppName string
param location string
param storageAccountName string
param appServicePlanName string
param applicationInsightsName string

// Fetch the resource ID for the Storage Account dynamically
resource storageAccount 'Microsoft.Storage/storageAccounts@2021-04-01' existing = {
  name: storageAccountName
  scope: resourceGroup()
}

// Create a new App Service Plan in the Consumption plan (Dynamic Tier)
resource appServicePlan 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: appServicePlanName // You can use a dynamic name or pass one as a parameter
  location: location
  sku: {
    name: 'Y1' // Consumption Plan SKU (Dynamic)
    tier: 'Dynamic' // Tier for Consumption plan
  }
  kind: 'functionapp' // This ensures the plan is for function apps
}


// Fetch the resource ID for Application Insights dynamically
resource applicationInsights 'Microsoft.Insights/components@2020-02-02' existing = {
  name: applicationInsightsName
  scope: resourceGroup()
}

// Function App resource
resource functionApp 'Microsoft.Web/sites@2022-03-01' = {
  name: functionAppName
  location: location
  kind: 'functionapp'
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      appSettings: [
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4' // Use the version that suits your requirements
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'node' // Change this to 'dotnet', 'python', etc.
        }
        {
          name: 'AzureWebJobsStorage'
          value: storageAccount.id
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: applicationInsights.properties.InstrumentationKey
        }
      ]
    }
  }
}

// Diagnostic Settings for Function App
resource diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01' = {
  name: '${functionAppName}-diagnostics'
  scope: functionApp
  properties: {
    logs: [
      {
        category: 'FunctionAppLogs'
        enabled: true
        retentionPolicy: {
          days: 30
          enabled: true
        }
      }
      {
        category: 'ApplicationInsights'
        enabled: true
        retentionPolicy: {
          days: 30
          enabled: true
        }
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
        retentionPolicy: {
          days: 30
          enabled: true
        }
      }
    ]
    destination: [
      {
        azureMonitor: {}
      }
      {
        eventHub: {} // Optional: You can add EventHub, LogAnalytics, etc. as destinations
      }
    ]
  }
}

output functionAppUrl string = functionApp.properties.defaultHostName
