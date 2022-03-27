param appConfigName string 
param rgLocation string = resourceGroup().location
param objectIds array


param values array = [
  { 
    name: 'Key1'
    value: 'item1'
  }
  { 
    name: 'Key2'
    value: 'item2'
  }
  { 
    name: 'Key3'
    value: 'item3'
  }
]

resource appconfig 'Microsoft.AppConfiguration/configurationStores@2021-10-01-preview' = {
  name: appConfigName
  location: rgLocation
  sku: {
    name: 'Free'
  }
  properties:{
    //Not working if local auth is disabled
     disableLocalAuth: false
  }
}

module roleAssingment 'roleAssignments/appconfg.assignments.bicep' = {
  name: 'roleassingmentAppconfg'
  params: {
    appConfigName: appConfigName
    rolesassignmentsList: objectIds
  }

  dependsOn:[
    appconfig
  ]
}

resource appconfigvalues 'Microsoft.AppConfiguration/configurationStores/keyValues@2021-10-01-preview' = [for item in values: {
  name: item.name
  parent: appconfig
  properties:{
    value: item.value
  }
  dependsOn:[
    roleAssingment
  ]
}]

 output appconfigId string = appconfig.id
 output appconfigEndpoint string = appconfig.properties.endpoint


