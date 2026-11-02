// Parámetros
@description('Región donde se despliega el App Service.')
param location string

@description('Nombre del plan de App Service.')
param appServicePlanName string

@description('Nombre de la aplicación web.')
param appServiceAppName string

@description('Runtime de Linux para la aplicación web.')
param linuxFxVersion string = 'DOTNETCORE|8.0'

@description('Endpoint de blob de la cuenta de almacenamiento asociada.')
param storageBlobEndpoint string

@description('FQDN del servidor lógico de SQL asociado.')
param sqlServerFqdn string

// Variables
var appServicePlanSkuName = {
  name: 'F1'
  tier: 'Free'
}

// Recursos
@description('Plan de App Service de Azure.')
resource appServicePlan 'Microsoft.Web/serverfarms@2024-04-01' = {
  name: appServicePlanName
  location: location
  sku: appServicePlanSkuName
  kind: 'linux'
  properties: {
    reserved: true
  }
}

@description('Aplicación web de Azure.')
resource appService 'Microsoft.Web/sites@2024-04-01' = {
  name: appServiceAppName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      linuxFxVersion: linuxFxVersion
      minTlsVersion: '1.2'
      appSettings: [
        {
          name: 'StorageBlobEndpoint'
          value: storageBlobEndpoint
        }
        {
          name: 'SqlServerFqdn'
          value: sqlServerFqdn
        }
      ]
    }
  }
}

// Salidas

@description('Task')
output appServiceAppName string = appService.name
output appServiceAppHostName string = appService.properties.defaultHostName


output appServicePlanId string = appServicePlan.id
output appServiceAppUrl string = 'https://${appService.properties.defaultHostName}'
