param kvfullName string
param myObjId string
param appConfigEndpoint string
param rgLocation string

resource mykv 'Microsoft.KeyVault/vaults@2021-11-01-preview' = {
  name: kvfullName
  location: rgLocation
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    accessPolicies: [
      {
        objectId: myObjId
        tenantId: subscription().tenantId
        permissions: {
          secrets: [
            'all'
          ]
        }
      }
    ]
  }
}

resource keyvaultSecrets 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = {
  name: 'AppConfigKeys'
  parent: mykv
  properties: {
    value: appConfigEndpoint
  }
}

output keyvaultUrl string = mykv.properties.vaultUri
