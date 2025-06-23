az login --service-principal `
  --username $env:AZURE_CLIENT_ID `
  --password $env:AZURE_CLIENT_SECRET `
  --tenant $env:AZURE_TENANT_ID

az account set --subscription $env:AZURE_SUBSCRIPTION_ID

az deployment sub create `
  --location northeurope `
  --template-file ./infra/main.bicep `
  --parameters location='northeurope' `
               environment='dev' `
               dbConnectionString=$env:DB_CONNECTION_STRING `
               subnetId='/subscriptions/463c86d6-9cbd-43b9-9bea-98b525b0e306/resourceGroups/knowledgehub/providers/Microsoft.Network/virtualNetworks/Spoke-VNet/subnets/App-Subnet'
