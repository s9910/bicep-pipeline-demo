// Parámetros
@description('Región donde se despliega la cuenta de almacenamiento.')
param location string

@description('Nombre de la cuenta de almacenamiento')
param storageAccountName string

// Variables
var storageAccountSkuName = 'Standard_LRS'

// Recursos
@description('Cuenta de almacenamiento de Azure.')
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: storageAccountSkuName
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
    allowBlobPublicAccess: false
  }
}

// Salidas
@description('Task')
output storageAccountId string = storageAccount.id


output storageAccountName string = storageAccount.name
output blobEndpoint string = storageAccount.properties.primaryEndpoints.blob
