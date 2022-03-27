param assingmentList array
param svcBusNameSpaceName string

resource serviceBusNameSpace 'Microsoft.ServiceBus/namespaces@2021-11-01' existing = {
  name: svcBusNameSpaceName
}

resource svcBusReceiverRole 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' existing = {
  name: '4f6d3b9b-027b-4f4c-9142-0e5a2a2247e0'
  scope: serviceBusNameSpace
}

//Assign service bus receiver role
resource receiverRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = [for item in assingmentList: {
  name: guid(item.id)
  properties: {
    principalId: item.id
    roleDefinitionId: svcBusReceiverRole.id
    principalType:item.type
  }
}]
