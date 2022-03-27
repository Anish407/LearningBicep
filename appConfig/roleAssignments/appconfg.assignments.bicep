param rolesassignmentsList array
param appConfigName string


resource appconfig 'Microsoft.AppConfiguration/configurationStores@2021-10-01-preview' existing ={
  name: appConfigName
} 

resource dataownerrole 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' existing = {
  name: '5ae67dd6-50cb-40e7-96ff-dc2bfa4b606b'
  scope: appconfig
}

// assign Owner role -- assign reader alone
// https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles
resource addroles 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = [for item in rolesassignmentsList: {
  name: guid(subscription().id, item.id)
  scope: appconfig
  properties: {
    principalId: item.id
    roleDefinitionId: dataownerrole.id
    principalType:item.type
  }
  dependsOn: [
    dataownerrole
  ]
}]
