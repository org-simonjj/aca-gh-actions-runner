param location string
param project string
param clientId string
param tags {
  *: string
}
@minLength(10)
param uniqueSuffix string

resource kv 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: take('kv-${project}-${uniqueSuffix}', 24)
  location: location
  tags: tags
  properties: {
    enableRbacAuthorization: false
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    accessPolicies: [
      {
        tenantId: subscription().tenantId
        objectId: clientId
        permissions: {
          keys: ['get', 'list', 'create', 'delete', 'backup', 'restore']
          secrets: ['get', 'list', 'set', 'delete']
          certificates: ['get', 'list', 'create', 'delete', 'import', 'update']
        }
      }]
  }
}

output name string = kv.name
