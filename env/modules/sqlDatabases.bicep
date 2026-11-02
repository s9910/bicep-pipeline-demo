// Parámetros
@description('Región donde se despliega el servidor lógico de SQL.')
param location string

@description('Nombre del servidor lógico de Azure SQL (único a nivel global).')
param sqlServerName string

@description('Nombre de la base de datos.')
param sqlDatabaseName string

@description('Usuario administrador del servidor lógico.')
param administratorLogin string

@description('Contraseña del usuario administrador.')
@secure()
param administratorLoginPassword string

// Variables
@description('SKU de la base de datos SQL.')
var databaseSkuName = {
  name: 'Basic'
  tier: 'Basic'
}

// Recursos
@description('Servidor lógico de SQL.')
resource sqlServer 'Microsoft.Sql/servers@2021-11-01' = {
  name: sqlServerName
  location: location
  properties: {
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    version: '12.0'
    minimalTlsVersion: '1.2'
  }
}

@description('Base de datos SQL asociada al servidor lógico.')
resource sqlDatabase 'Microsoft.Sql/servers/databases@2021-11-01' = {
  parent: sqlServer
  name: sqlDatabaseName
  location: location
  sku: databaseSkuName
}


// Salidas
@description('Task')
output sqlServerFqdn string = sqlServer.properties.fullyQualifiedDomainName
output sqlDatabaseName string = sqlDatabase.name

output sqlServerName string = sqlServer.name

