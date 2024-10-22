Create an Azure Policy to automatically add an `owner` tag to resources based on the user who creates them. However, Azure Policy does not directly support fetching the user who created the resource. Instead, you can use Azure Policy to enforce tagging and then use Azure Event Grid and Azure Functions to dynamically set the `owner` tag based on the resource creator.

### Step-by-Step Solution

1. **Azure Policy**: Enforce that an `owner` tag must be present.
2. **Azure Event Grid**: Trigger an event when a resource is created.
3. **Azure Function**: Set the `owner` tag based on the resource creator.

### Step 1: Azure Policy

Create an Azure Policy to enforce that an `owner` tag must be present on all resources.

#### Azure Policy Definition

```json
{
  "properties": {
    "displayName": "Enforce owner tag on resources",
    "policyType": "Custom",
    "mode": "Indexed",
    "description": "Ensure that an owner tag is present on all resources.",
    "parameters": {
      "tagName": {
        "type": "String",
        "metadata": {
          "description": "Name of the tag to enforce",
          "displayName": "Tag Name",
          "defaultValue": "owner"
        }
      }
    },
    "policyRule": {
      "if": {
        "field": "[concat('tags[', parameters('tagName'), ']')]",
        "exists": "false"
      },
      "then": {
        "effect": "modify",
        "details": {
          "roleDefinitionIds": [
            "/providers/microsoft.authorization/roleDefinitions/1234567890"
          ],
          "operations": [
            {
              "operation": "add",
              "field": "[concat('tags[', parameters('tagName'), ']')]",
              "value": "[concat('user:', requestContext().user.name)]"
            }
          ]
        }
      }
    }
  }
}
```

#### Assign the Policy

```bash
az policy definition create --name 'enforce-owner-tag' --display-name 'Enforce owner tag on resources' --description 'Ensure that an owner tag is present on all resources.' --rules 'policy-definition.json' --mode Indexed

az policy assignment create --policy 'enforce-owner-tag' --scope '/subscriptions/{subscription-id}'
```

### Step 2: Azure Event Grid

Create an Event Grid subscription to trigger an event when a resource is created.

```bash
az eventgrid event-subscription create \
  --name ResourceCreatedSubscription \
  --source-resource-id /subscriptions/{subscription-id} \
  --endpoint-type storagequeue \
  --endpoint /subscriptions/{subscription-id}/resourceGroups/{resource-group}/providers/Microsoft.Storage/storageAccounts/{storage-account}/queueServices/default/queues/{queue-name}
```

### Step 3: Azure Function

Create an Azure Function to set the `owner` tag based on the resource creator.

#### Azure Function Code (Python Example)

```python
import logging
import os
import json
import azure.functions as func
from azure.identity import DefaultAzureCredential
from azure.mgmt.resource import ResourceManagementClient

def main(event: func.EventGridEvent):
    logging.info('Python EventGrid trigger processed an event: %s', event.get_json())

    resource_id = event.subject
    user_email = event.get_json().get('data', {}).get('claims', {}).get('http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress')

    if not user_email:
        logging.error('User email not found in event data')
        return

    credential = DefaultAzureCredential()
    client = ResourceManagementClient(credential, os.environ['AZURE_SUBSCRIPTION_ID'])

    resource = client.resources.get_by_id(resource_id, api_version='2021-04-01')
    tags = resource.tags or {}
    tags['owner'] = user_email

    client.resources.update_by_id(resource_id, api_version='2021-04-01', parameters={'tags': tags})
```

#### Deploy the Azure Function

1. Create a new Function App in the Azure Portal.
2. Deploy the above Python code to the Function App.
3. Set the `AZURE_SUBSCRIPTION_ID` application setting in the Function App.

### Summary

By combining Azure Policy, Azure Event Grid, and Azure Functions, you can automatically add an `owner` tag to resources based on the user who creates them. The Azure Policy ensures that the `owner` tag is present, the Event Grid triggers an event when a resource is created, and the Azure Function sets the `owner` tag based on the resource creator.
