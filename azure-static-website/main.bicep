param storageAccountName string

// Existing Storage Account
resource storageAccount 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: storageAccountName
  location: resourceGroup().location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
  }
}

// Blue Storage Account
resource blueStorageAccount 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: '${storageAccountName}blue'
  location: resourceGroup().location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
  }
}

// Green Storage Account
resource greenStorageAccount 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: '${storageAccountName}green'
  location: resourceGroup().location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
  }
}

// CDN Profile
resource cdnProfile 'Microsoft.Cdn/profiles@2020-09-01' = {
  name: 'azure-devops-cdn'
  location: 'global'
  sku: {
    name: 'Standard_Akamai'
  }
}

// CDN Endpoint for Blue
resource blueCdnEndpoint 'Microsoft.Cdn/profiles/endpoints@2020-09-01' = {
  name: 'azure-devops-cdn/blueEndpoint'
  location: 'global'
  properties: {
    originHostHeader: '${storageAccountName}blue.blob.core.windows.net'
    origins: [
      {
        name: 'blue-origin'
        properties: {
          hostName: '${storageAccountName}blue.blob.core.windows.net'
        }
      }
    ]
  }
  dependsOn: [
    cdnProfile
    blueStorageAccount
  ]
}

// CDN Endpoint for Green
resource greenCdnEndpoint 'Microsoft.Cdn/profiles/endpoints@2020-09-01' = {
  name: 'azure-devops-cdn/greenEndpoint'
  location: 'global'
  properties: {
    originHostHeader: '${storageAccountName}green.blob.core.windows.net'
    origins: [
      {
        name: 'green-origin'
        properties: {
          hostName: '${storageAccountName}green.blob.core.windows.net'
        }
      }
    ]
  }
  dependsOn: [
    cdnProfile
    greenStorageAccount
  ]
}
