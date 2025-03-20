module monitoring 'br/public:avm/ptn/azd/monitoring:0.1.0' = {
  name: 'monitoring'
  params: {
    logAnalyticsName: 'loganalyticsrrf'
    applicationInsightsName: 'appinsightsrrf'
    applicationInsightsDashboardName: 'dashboardrrf'
    location: location
    tags: tags
  }
}



module serverfarm 'br/public:avm/res/web/serverfarm:0.4.0' = {
  name: 'serverfarmDeployment'
  params: {
    name: 'simpleapprrf-plan'
    location: location
    tags: tags
    kind: 'linux'
    skuName: 'B3'
    skuCapacity: 1
    diagnosticSettings: [
      {
        name: 'basicSetting'
        workspaceResourceId: monitoring.outputs.logAnalyticsWorkspaceResourceId
      }
    ]
  }
}

module conferenceAPI 'br/public:avm/res/web/site:0.12.0' = {
  name: 'conferenceAPIDeployment'
  params: {
    kind: 'app'

    name: 'simpleapprrf'
    serverFarmResourceId: serverfarm.outputs.resourceId
    
    httpsOnly: true
    location: location

    publicNetworkAccess: 'Enabled'

    siteConfig: {
      alwaysOn: true
      metadata: [
        {
          name: 'CURRENT_STACK'
          value: 'dotnetcore'
        }
      ]
    }
    
  }
}
