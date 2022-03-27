@description('Environment Name')
param environment string 
@description('Keyvault Name')
param keyvaultName string
param appConfigName string

var appConfigFullName= 'anish${appConfigName}${environment}'
var kvfullname  = '${keyvaultName}${environment}'
var myObjId = 'f32f3633-dab2-4828-93d7-57f28b39e6f1'
param rgLocation string = resourceGroup().location
var userMsiName= '${environment}msi'

var svcBusName= '${environment}anishsvcbicepbus'
var svcBusTopicName = '${environment}anishsvcbicepTopic'
var appservicePlanName ='${environment}anishbciepplan'
var appserviceName ='${environment}anishbciepapp'


module userMsi 'user_Assigned_Identity/userassignedIdenity.bicep'={
  name: 'UserAssignedManagedIdentity'
  params: {
    location: rgLocation
    userMsiName: userMsiName
  }
}

module appconfigsetup 'appConfig/appconfig.bicep' ={
  name: 'appconfigsetup'
  params: {
    appConfigName: appConfigFullName
    rgLocation: rgLocation
    objectIds:[ 
      {
        id: userMsi.outputs.userMsiId
        type: 'ServicePrincipal'
      }
      {
        id: 'f32f3633-dab2-4828-93d7-57f28b39e6f1'
        type: 'User'
      }
    ]
  }
}

module keyavultsetup 'keyvault/keyvault.bicep' ={
  name: 'keyvaultSetup'
  params:{
    kvfullName: kvfullname
    appConfigEndpoint:appconfigsetup.outputs.appconfigEndpoint
    myObjId:myObjId
    rgLocation:rgLocation
  }
  dependsOn:[
     appconfigsetup 
    ]
}

module svcBusConfiguration 'service_bus/servicebus.bicep' ={
  name: 'svcBusConfiguration'
  params: {
    location: rgLocation
    roleAssignmentList: [ 
      {
        id: userMsi.outputs.userMsiId
        type: 'ServicePrincipal'
      }
      {
        id: 'f32f3633-dab2-4828-93d7-57f28b39e6f1'
        type: 'User'
      }
    ]
    svcbusName: svcBusName
    svcBusTopicName: svcBusTopicName
  }
}

module appService 'app_service/appservice.bicep' = {
  name: 'Appservice'
  params: {
    appserviceName: appserviceName
    appServicePlanName:  appservicePlanName
    location: rgLocation
    userAssginedId: userMsi.outputs.userMsiResourceId
    appsettings: [
      {
        key : 'keyvaulturl'
        value: keyavultsetup.outputs.keyvaultUrl
      }
      {
        key:'msiId'
        value : userMsi.outputs.userMsiId
      }
    ]
  }
  dependsOn:[
    keyavultsetup
    userMsi
  ]
}




