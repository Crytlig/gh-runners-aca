resource ca 'Microsoft.App/containerApps@2023-05-01' = {
  name: 'ca'
  location: 'westeurope'

  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {}
  }
  
  properties: {
    template: {
      containers: [
        {
          name: 'github-runner'
          image: 'ghrunnerdevweacr.azurecr.io/ghrunner:0.0.1'
          resources: {
            cpu: 1
            memory: '0.5Gi'
          }

          env: [
            {
              name: 'GH_OWNER'
              value: 'crytlig'
            }
            {
              name: 'GH_REPOSITORY'
              value: 'gh-runners-aca'
            }
            {
              secretRef: 'token'
              name: 'GH_TOKEN'
            }
          ]
        }
      ]
      scale: {
        maxReplicas: 2
        minReplicas: 1
        rules: [
          {
            custom: {
              auth: [
                {
                  secretRef: 
                }
              ]
            }
          }
        ]
      }
    }
  }
}
