@description('Azure region to deploy the resources to.')
param location string

@description('Name prefix for the resources.')
param namePrefix string

@allowed([ 'dev', 'test', 'prod' ])
@description('Evironment postfix for the resources.')
param environment string

@description('Object ID of Databricks Access Connector.')
// Search for `2ff814a6-3304-4ab8-85cb-cd0e6f879c1d`.
param databricksObjectId string

var name = '${namePrefix}-kv-${environment}'

resource keyvault 'Microsoft.KeyVault/vaults@2019-09-01' = {
  name: name
  location: location

  properties: {
    tenantId: subscription().tenantId
    sku: {
      family: 'A'
      name: 'standard'
    }
    enabledForTemplateDeployment: false
    accessPolicies: [
      {
        objectId: databricksObjectId
        tenantId: subscription().tenantId
        permissions: {
          keys: [ 'Get', 'List' ]
          secrets: [ 'Get', 'List' ]
          certificates: [ 'Get', 'List' ]
        }
      }
    ]
  }
}
