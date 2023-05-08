@description('Azure region to deploy the resources to.')
param location string = resourceGroup().location

@description('Name prefix for the resources.')
param namePrefix string

@allowed([ 'dev', 'test', 'prod' ])
@description('Evironment postfix for the resources.')
param environment string

@description('Object ID of Databricks Access Connector.')
// Search for `2ff814a6-3304-4ab8-85cb-cd0e6f879c1d`.
param databricksObjectId string

module storageAccount 'modules/storageAccount.bicep' = {
  name: 'storageAccount'
  params: {
    location: location
    namePrefix: namePrefix
    environment: environment
  }
}

module databricksWorkspace 'modules/databricks.bicep' = {
  name: 'databricks'
  params: {
    location: location
    namePrefix: namePrefix
    environment: environment
  }
}

module keyVault 'modules/keyVault.bicep' = {
  name: 'keyVault'
  params: {
    location: location
    namePrefix: namePrefix
    environment: environment
    databricksObjectId: databricksObjectId
  }
}

module dataFactory 'modules/datafactory.bicep' = {
  name: 'dataFactory'
  params: {
    location: location
    namePrefix: namePrefix
    environment: environment
  }
}
