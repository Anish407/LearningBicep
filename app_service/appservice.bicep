param location string
param appServicePlanName string
param appserviceName string
param userAssginedId string
param appsettings array

resource appServicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: 'S1'
  }
  kind: 'Windows'
  properties: {
    reserved: true
  }
}

resource appService 'Microsoft.Web/sites@2020-06-01' = {
  name: appserviceName
  location: location
  kind: 'app'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${userAssginedId}' :{}
    }
  }
  properties: {
    serverFarmId: appServicePlan.id
    clientAffinityEnabled:false
    siteConfig: {
     alwaysOn: true
     ftpsState: 'Disabled'
    }
  }
}

// resource appSettings 'Microsoft.Web/sites/config@2021-03-01' = [for item in appsettings: {
//   name: 'appsettings'

//   parent:appService
//   properties:{
//     '${item.key}': '${item.value}'
//   }
 
//   dependsOn:[
//     appServicePlan
//   ]
// }]

resource appSettings 'Microsoft.Web/sites/config@2021-03-01' =  {
  name: 'appsettings'
  parent:appService
  properties:{
    '${appsettings[0].key}': '${appsettings[0].value}'
    '${appsettings[1].key}': '${appsettings[1].value}'
  }

  dependsOn:[
    appServicePlan
  ]
}





