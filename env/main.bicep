// Parámetros Basicos
@description('Región de despliegue de todos los recursos.')
param location string = resourceGroup().location

// Azure SQL no está habilitado en todas las regiones para esta suscripción.
@description('Región de despliegue del servidor lógico de SQL.')
param sqlLocation string = location

@description('Prefijo del proyecto para los recursos')
param projectName string
@description('Suffix único para los recursos.')
param uniqueSuffix string = substring(uniqueString(resourceGroup().id), 0, 6)
param uniqueSqlSuffix string = substring(uniqueString(resourceGroup().id, sqlLocation), 0, 6)

@description('Tipo de ambiente de despliegue: prod o nonprod.')
@allowed([
  'nonprod'
  'prod'
])
param environmentType string

// Otros Parametros

@description('Usuario administrador del servidor lógico de SQL.')
param sqlAdministratorLogin string

@description('Contraseña del administrador de SQL. Se solicita al desplegar.')
@secure()
param sqlAdministratorLoginPassword string


// Nombres de los Parametros
@description('Nombre para los recursos.')
param storageAccountName string = 'st${projectName}${environmentType}${uniqueSuffix}'
// El sufijo incluye sqlLocation para que el nombre del servidor cambie al cambiar de región.
param sqlServerName string = 'sqls-${projectName}-${environmentType}-${uniqueSqlSuffix}'
param sqlDatabaseName string = 'sqldb-${projectName}-${environmentType}-${uniqueSqlSuffix}'

// Recursos (módulos)
module storage 'modules/storageAccounts.bicep' = {
  name: 'deploy-storage'
  params: {
    location: location
    storageAccountName: storageAccountName
  }
}


module sql 'modules/sqlDatabases.bicep' = {
  name: 'deploy-sql'
  params: {
    location: sqlLocation
    sqlServerName: sqlServerName
    sqlDatabaseName: sqlDatabaseName
    administratorLogin: sqlAdministratorLogin
    administratorLoginPassword: sqlAdministratorLoginPassword
  }
}

// Salidas
@description('Id de la cuenta de almacenamiento.')
output storageAccountId string = storage.outputs.storageAccountId

@description('FQDN del servidor lógico de SQL.')
output sqlServerFqdn string = sql.outputs.sqlServerFqdn

@description('Nombre de la base de datos.')
output sqlDatabaseName string = sql.outputs.sqlDatabaseName
