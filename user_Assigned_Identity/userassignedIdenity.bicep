param userMsiName string 
param location string

resource usermsi 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: userMsiName
  location: location
}

output userMsiId string = usermsi.properties.clientId
output userMsiResourceId string = usermsi.id 
