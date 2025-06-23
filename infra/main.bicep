param location string
param environment string
param dbConnectionString string
param subnetId string  

resource appPlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: 'appsvc-plan-${environment}'
  location: location
  sku: {
    name: 'B1'
    tier: 'Basic'
  }
  kind: 'linux'
  properties: {
    reserved: true
  }
}

resource webApp 'Microsoft.Web/sites@2022-09-01' = {
  name: 'monitoring-api-${environment}'
  location: location
  kind: 'app,linux,container'
  properties: {
    serverFarmId: appPlan.id
    siteConfig: {
      linuxFxVersion: 'DOCKER|adela2345/monitoringapi:latest'
      appSettings: [
        {
          name: 'DB_CONNECTION'
          value: dbConnectionString
        }
        {
          name: 'WEBSITES_PORT'
          value: '80'
        }
      ]
    }
  }
}

// Correct way to link to subnet for VNet integration
resource vnetIntegration 'Microsoft.Web/sites/virtualNetworkConnections@2022-03-01' = {
  name: '${webApp.name}/vnet'
  location: location
  properties: {
    subnetResourceId: subnetId
    isSwift: true
  }
  dependsOn: [
    webApp
  ]
}

output webAppUrl string = webApp.properties.defaultHostName
