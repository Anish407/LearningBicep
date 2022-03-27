@description('Service bus Name')
param svcbusName string

param svcBusTopicName string 

param roleAssignmentList array

param location string

//create the namespace
resource svcBusNameSpace 'Microsoft.ServiceBus/namespaces@2021-11-01' ={
  name: svcbusName 
  location: location

  properties:{
    disableLocalAuth:true
  }
  identity:{
    type:'SystemAssigned'
  }
}

//create topic
resource svcbusTopic 'Microsoft.ServiceBus/namespaces/topics@2021-11-01' = {
  name: svcBusTopicName
  parent:svcBusNameSpace
}

//Assign svc bus roles
module svcRoleAssignment 'role_assignments/servicebus_roleAssignments.bicep' ={
  name: 'svcRoleAssignment'
  params: {
    assingmentList: roleAssignmentList
    svcBusNameSpaceName:svcbusName
  }

  dependsOn:[
    svcBusNameSpace
    svcbusTopic
  ]
}

output svcBusEndpoint string = svcBusNameSpace.properties.serviceBusEndpoint
output svcBusIdentityId string = svcBusNameSpace.identity.principalId


