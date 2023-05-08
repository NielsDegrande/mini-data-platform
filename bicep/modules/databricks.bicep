@description('Azure region to deploy the resources to.')
param location string

@description('Name prefix for the resources.')
param namePrefix string

@allowed([ 'dev', 'test', 'prod' ])
@description('Evironment postfix for the resources.')
param environment string

@allowed([ 'standard', 'premium', 'trial' ])
@description('SKU for the resources.')
param sku string = 'trial'

var accessConnectorName = '${namePrefix}-dbr-ac-${environment}'
var databricksWorkspaceName = '${namePrefix}-dbr-ws-${environment}'
var managedResourceGroupName = '${namePrefix}-dbr-rg-${environment}'

resource databricksWorkspace 'Microsoft.Databricks/workspaces@2018-04-01' = {
  name: databricksWorkspaceName
  location: location
  sku: {
    name: sku
  }
  properties: {
    managedResourceGroupId: subscriptionResourceId('Microsoft.Resources/resourceGroups', managedResourceGroupName)
    authorizations: []
  }
}

output workspace object = databricksWorkspace

resource databricksAccessConnector 'Microsoft.Databricks/accessConnectors@2022-04-01-preview' = {
  name: accessConnectorName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {}
}

output accessConnectorId string = databricksAccessConnector.identity.principalId
