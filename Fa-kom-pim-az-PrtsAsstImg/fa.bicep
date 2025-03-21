param functionAppName string
param location string
param storageAccountName string
param appServicePlanName string
param applicationInsightsName string
param logAnalyticsWorkspaceName string
param FUNCTIONS_EXTENSION_VERSION string
param FUNCTIONS_WORKER_RUNTIME string
param WEBSITE_RUN_FROM_PACKAGE string
param resourceGroupName string
param APPINSIGHTS_INSTRUMENTATIONKEY string
param APPLICATIONINSIGHTS_CONNECTION_STRING string
param AzureWebJobsStorage string
param AemMediaZipCopyQueueName string
param AemMediaZipUnzipQueueName string
param AWSS3AcessKey string
param AWSS3BucketName string 
param AWSS3FilePattern string 
param AWSS3FolderPath string 
param AWSS3SecretKey string 
param AzureStorageConnectionString string
param mfun_http_procPrtsAsstImgMetaToAzBlob string
param mfun_http_rcvPrtsAsstImgZipFromPim string
param mfun_sb_copyPrtsAsstImgMediaFromPIM string
param Mfun_sch_procPrtsAsstImgMetaToAzBlob string
param mfun_sch_purgePrtsAsstImgTxTables string
param mfun_sch_rcvPrtsAsstImgFromPIM string
param mfun_sch_rcvPrtsAsstImgMetaAndMediaListFromPim string
param mfun_sch_rcvPrtsAsstImgZipFromPim string
param CommonAzureServiceClientId string
param CommonAzureServiceClientSecret string
param CommonAzureServiceScope string
param CommonAzureServiceTokenUrl string
param CommonCustomLogServiceUri string
param CommonEmailServiceCcEmail string
param CommonEmailServiceFromEmail string
param CommonEmailServiceToEmail string
param CommonEmailServiceUri string
param Environment string
param IgnoredSpecialCharacters string
param InboundContainerName string
param MaxDegreeOfParallelismCopyzip string
param MaxDegreeOfParallelismSplitFile string
param MaxMediaFileChunkSize string
param MediaBlobPath string
param MetaDataBlobPath string
param PartsAssetBatchFilesProcessInfoTableName string
param PartsAssetBatchRunInfoTableName string
param PartsAssetPartRunInfoTableName string
param ProcPrtsAsstImgMetaToAzBlobSchedule string
param RcvPrtsAsstImgMetaAndMediaListFromPimSchedule string
param ServiceBusConnectionString string
param WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED string
param WEBSITE_VNET_ROUTE_ALL string
param existingKeyVaultName string


// Fetch the resource ID for the Storage Account dynamically
resource storageAccount 'Microsoft.Storage/storageAccounts@2021-02-01' existing = {
  name: storageAccountName
  scope: resourceGroup()
}

 //Fetch the Storage Account Keys
 //var storageAccountKey = listKeys(storageAccount.id, storageAccount.apiVersion).keys[0].value

// Construct the Connection String
//var storageConnectionString = 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};AccountKey=${storageAccountKey};EndpointSuffix=${environment().suffixes.storage}'

// Create a new App Service Plan in the Consumption plan (Dynamic Tier)
resource appServicePlan 'Microsoft.Web/serverfarms@2021-02-01' existing = {
  name: appServicePlanName // You can use a dynamic name or pass one as a parameter
}

// Fetch the resource ID for Application Insights dynamically
resource applicationInsights 'Microsoft.Insights/components@2020-02-02' existing = {
  name: applicationInsightsName
  scope: resourceGroup()
}

// Fetch the resource ID of the existing Log Analytics Workspace dynamically
resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2020-08-01' existing = {
  name: logAnalyticsWorkspaceName
  scope: resourceGroup('d-rg-apicompute')  
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
          value: FUNCTIONS_EXTENSION_VERSION // Parameterized
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: FUNCTIONS_WORKER_RUNTIME // Parameterized
        }
        {
          name: 'AzureWebJobsStorage'
          value: AzureWebJobsStorage
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: APPINSIGHTS_INSTRUMENTATIONKEY // Parameterized
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: APPLICATIONINSIGHTS_CONNECTION_STRING
        }
        {
          name: 'WEBSITE_RUN_FROM_PACKAGE'
          value: WEBSITE_RUN_FROM_PACKAGE // Parameterized
        }

        {
          name: 'AemMediaZipCopyQueueName'
          value: AemMediaZipCopyQueueName // Parameterized
        }
        {
          name: 'AemMediaZipUnzipQueueName'
          value: AemMediaZipUnzipQueueName // Parameterized
        }
        {
          name: 'AWSS3AcessKey'
          value: AWSS3AcessKey // Parameterized
        }
        {
          name: 'AWSS3BucketName'
          value: AWSS3BucketName // Parameterized
        }
        {
          name: 'AWSS3FilePattern'
          value: AWSS3FilePattern // Parameterized
        }
        {
          name: 'AWSS3FolderPath'
          value: AWSS3FolderPath // Parameterized
        }
        {
          name: 'AWSS3SecretKey'
          value: AWSS3SecretKey // Parameterized
        }
        {
          name: 'AzureStorageConnectionString'
          value: AzureStorageConnectionString // Parameterized
        }
        {
          name: 'mfun_http_procPrtsAsstImgMetaToAzBlob'
          value: mfun_http_procPrtsAsstImgMetaToAzBlob // Parameterized
        }
        {
          name: 'mfun_http_rcvPrtsAsstImgZipFromPim'
          value: mfun_http_rcvPrtsAsstImgZipFromPim // Parameterized
        }
        {
          name: 'mfun_sb_copyPrtsAsstImgMediaFromPIM'
          value: mfun_sb_copyPrtsAsstImgMediaFromPIM // Parameterized
        }
        {
          name: 'Mfun_sch_procPrtsAsstImgMetaToAzBlob'
          value: Mfun_sch_procPrtsAsstImgMetaToAzBlob // Parameterized
        }
        {
          name: 'CommonEmailServiceToEmail'
          value: CommonEmailServiceToEmail // Parameterized
        }
        {
          name: 'mfun_sch_purgePrtsAsstImgTxTables'
          value: mfun_sch_purgePrtsAsstImgTxTables // Parameterized
        }
        {
          name: 'mfun_sch_rcvPrtsAsstImgFromPIM'
          value: mfun_sch_rcvPrtsAsstImgFromPIM // Parameterized
        }
        {
          name: 'mfun_sch_rcvPrtsAsstImgMetaAndMediaListFromPim'
          value: mfun_sch_rcvPrtsAsstImgMetaAndMediaListFromPim // Parameterized
        }
        {
          name: 'mfun_sch_rcvPrtsAsstImgZipFromPim'
          value: mfun_sch_rcvPrtsAsstImgZipFromPim // Parameterized
        }
        {
          name: 'mfun_sch_rcvPrtsAsstImgZipFromPim'
          value: PartsAssetBatchFilesProcessInfoTableName // Parameterized
        }
        {
          name: 'CommonAzureServiceClientId'
          value: CommonAzureServiceClientId // Parameterized
        }
        {
          name: 'CommonAzureServiceClientSecret'
          value: CommonAzureServiceClientSecret // Parameterized
        }
        {
          name: 'CommonAzureServiceScope'
          value: CommonAzureServiceScope // Parameterized
        }
        {
          name: 'CommonAzureServiceTokenUrl'
          value: CommonAzureServiceTokenUrl // Parameterized
        }
        {
          name: 'CommonCustomLogServiceUri'
          value: CommonCustomLogServiceUri // Parameterized
        }
        {
          name: 'CommonEmailServiceCcEmail'
          value: CommonEmailServiceCcEmail // Parameterized
        }
        {
          name: 'CommonEmailServiceFromEmail'
          value: CommonEmailServiceFromEmail // Parameterized
        }
        {
          name: 'CommonEmailServiceToEmail'
          value: CommonEmailServiceToEmail // Parameterized
        }
        {
          name: 'CommonEmailServiceUri'
          value: CommonEmailServiceUri // Parameterized
        }

        {
          name: 'Environment'
          value: Environment // Parameterized
        }
        {
          name: 'FunctionAppName'
          value: functionAppName // Parameterized
        }
        {
          name: 'IgnoredSpecialCharacters'
          value: IgnoredSpecialCharacters // Parameterized
        }
        {
          name: 'InboundContainerName'
          value: InboundContainerName // Parameterized
        }
        {
          name: 'MaxDegreeOfParallelismCopyzip'
          value: MaxDegreeOfParallelismCopyzip // Parameterized
        }
        {
          name: 'MaxDegreeOfParallelismSplitFile'
          value: MaxDegreeOfParallelismSplitFile // Parameterized
        }
        {
          name: 'MaxMediaFileChunkSize'
          value: MaxMediaFileChunkSize // Parameterized
        }
        {
          name: 'MediaBlobPath'
          value: MediaBlobPath // Parameterized
        }
        {
          name: 'MetaDataBlobPath'
          value: MetaDataBlobPath // Parameterized
        }
        {
          name: 'PartsAssetBatchFilesProcessInfoTableName'
          value: PartsAssetBatchFilesProcessInfoTableName // Parameterized
        }
        {
          name: 'PartsAssetBatchRunInfoTableName'
          value: PartsAssetBatchRunInfoTableName // Parameterized
        }
        {
          name: 'PartsAssetPartRunInfoTableName'
          value: PartsAssetPartRunInfoTableName // Parameterized
        }
        {
          name: 'ProcPrtsAsstImgMetaToAzBlobSchedule'
          value: ProcPrtsAsstImgMetaToAzBlobSchedule // Parameterized
        }
        {
          name: 'RcvPrtsAsstImgMetaAndMediaListFromPimSchedule'
          value: RcvPrtsAsstImgMetaAndMediaListFromPimSchedule // Parameterized
        }
        {
          name: 'ServiceBusConnectionString'
          value: ServiceBusConnectionString // Parameterized
        }
        {
          name: 'WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED'
          value: WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED // Parameterized
        }
        {
          name: 'WEBSITE_VNET_ROUTE_ALL'
          value: WEBSITE_RUN_FROM_PACKAGE // Parameterized
        }
      ]
      cors: {
        allowedOrigins: [
          'https://portal.azure.com'
        ] // Add portal.azure.com to the allowed origins dynamically
      }
    }
  }
}


// Diagnostic Settings for Function App
  resource diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: '${functionAppName}-diagnostics'
  scope: functionApp
  properties: {
    logs: [
      {
        category: 'FunctionAppLogs'
        enabled: true
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
    workspaceId: logAnalyticsWorkspace.id    
  }
}
output functionAppUrl string = functionApp.properties.defaultHostName
