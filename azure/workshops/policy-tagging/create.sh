## step 1: Create a policy definition
az policy definition create --name 'enforce-owner-tag' --display-name 'Enforce owner tag on resources' --description 'Ensure that an owner tag is present on all resources.' --rules 'policy-definition.json' --mode Indexed

az policy assignment create --policy 'enforce-owner-tag' --scope '/subscriptions/{subscription-id}'

## step 2: Create a eventgrid
az eventgrid event-subscription create \
  --name ResourceCreatedSubscription \
  --source-resource-id /subscriptions/{subscription-id} \
  --endpoint-type storagequeue \
  --endpoint /subscriptions/{subscription-id}/resourceGroups/{resource-group}/providers/Microsoft.Storage/storageAccounts/{storage-account}/queueServices/default/queues/{queue-name}

## step 3: Create an azure function (python script)
az functionapp create --resource-group {resource-group} --consumption-plan-location {location} --name {function-app-name} --storage-account {storage-account} --runtime python --functions-version 3  