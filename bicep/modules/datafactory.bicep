@description('Azure region to deploy the resources to.')
param location string

@description('Name prefix for the resources.')
param namePrefix string

@allowed([ 'dev', 'test', 'prod' ])
@description('Evironment postfix for the resources.')
param environment string

var name = '${namePrefix}-df-${environment}'

resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01' = {
  name: name
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {}
}
