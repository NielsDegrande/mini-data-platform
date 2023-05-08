@description('Azure region to deploy the resources to.')
param location string

@description('Name prefix for the resources.')
param namePrefix string

@allowed([ 'dev', 'test', 'prod' ])
@description('Evironment postfix for the resources.')
param environment string

@allowed([ 'Standard_LRS' ])
@description('SKU for the resources.')
param sku string = 'Standard_LRS'

@description('Containers to create in Storage Account.')
param containerNames array = [
  'raw'
  'curated'
]

// Storage account name cannot contain `-`. It should also be between 3 and 24 characters.
var storageAccountName = replace('${namePrefix}sa${environment}${take(uniqueString(resourceGroup().id), 5)}', '-', '')

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: sku
  }
  properties: {
    accessTier: 'Hot'
    supportsHttpsTrafficOnly: true
    isHnsEnabled: true
    encryption: {
      keySource: 'Microsoft.Storage'
      services: {
        blob: {
          enabled: true
        }
        file: {
          enabled: true
        }
      }
    }
  }
}

output storageAccountId string = storageAccount.id

resource blobServices 'Microsoft.Storage/storageAccounts/blobServices@2022-09-01' = {
  parent: storageAccount
  name: 'default'
}

resource blob 'Microsoft.Storage/storageAccounts/blobServices/containers@2019-06-01' = [for name in containerNames: {
  parent: blobServices
  name: name
}]
