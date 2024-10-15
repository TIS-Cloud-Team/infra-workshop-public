### Explanation of Azure Policy Definition

This Azure Policy definition ensures that an `owner` tag is present on all resources. If the `owner` tag is missing, the policy will automatically add it with the value set to the user who created the resource.

#### Key Components

1. **`displayName`**: The name of the policy.
2. **`policyType`**: Indicates that this is a custom policy.
3. **`mode`**: Specifies the mode of the policy. `Indexed` mode is used for policies that apply to resource types that support tags.
4. **`description`**: A brief description of what the policy does.
5. **[`parameters`](command:_github.copilot.openSymbolFromReferences?%5B%22%22%2C%5B%7B%22uri%22%3A%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2FUsers%2Fjonathanlin%2Fdev%2FTIS-Cloud_Team%2Finfra-workshop-public%2Fpolicy-tagging%2Fazure-policy-definition.json%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%22pos%22%3A%7B%22line%22%3A30%2C%22character%22%3A41%7D%7D%5D%2C%22642e85b5-5320-4b60-9106-0e0d75f5727e%22%5D "Go to definition")**: Defines the parameters for the policy. In this case, it defines the [`tagName`](command:_github.copilot.openSymbolFromReferences?%5B%22%22%2C%5B%7B%22uri%22%3A%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2FUsers%2Fjonathanlin%2Fdev%2FTIS-Cloud_Team%2Finfra-workshop-public%2Fpolicy-tagging%2Fazure-policy-definition.json%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%22pos%22%3A%7B%22line%22%3A30%2C%22character%22%3A53%7D%7D%5D%2C%22642e85b5-5320-4b60-9106-0e0d75f5727e%22%5D "Go to definition") parameter with a default value of `owner`.
6. **`policyRule`**: The rule that the policy enforces.
   - **`if`**: The condition to check. It checks if the specified tag (`owner` by default) does not exist.
   - **`then`**: The action to take if the condition is met. It modifies the resource to add the `owner` tag with the value set to the user who created the resource.

#### JSON Excerpt

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

### Creating the Policy Using Azure CLI

You can create and assign this policy using the Azure CLI.

#### Create the Policy Definition

```bash
az policy definition create --name 'enforce-owner-tag' --display-name 'Enforce owner tag on resources' --description 'Ensure that an owner tag is present on all resources.' --rules 'azure-policy-definition.json' --mode Indexed
```

#### Assign the Policy

```bash
az policy assignment create --policy 'enforce-owner-tag' --scope '/subscriptions/{subscription-id}'
```

### Creating the Policy Using Terraform

You can also create and assign this policy using Terraform.

#### Terraform Configuration

```terraform
provider "azurerm" {
  features {}
}

resource "azurerm_policy_definition" "enforce_owner_tag" {
  name         = "enforce-owner-tag"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Enforce owner tag on resources"
  description  = "Ensure that an owner tag is present on all resources."

  policy_rule = <<POLICY_RULE
{
  "if": {
    "field": "[concat('tags[', parameters('tagName'), ']')]",
    "exists": "false"
  },
  "then": {
    "effect": "modify",
    "details": {
      "roleDefinitionIds": [
        "/providers/microsoft.authorization/roleDefinitions/8e3af657-a8ff-443c-a75c-2fe8c4bcb635"
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
POLICY_RULE

  parameters = <<PARAMETERS
{
  "tagName": {
    "type": "String",
    "metadata": {
      "description": "Name of the tag to enforce",
      "displayName": "Tag Name",
      "defaultValue": "owner"
    }
  }
}
PARAMETERS
}

resource "azurerm_policy_assignment" "enforce_owner_tag" {
  name                 = "enforce-owner-tag"
  policy_definition_id = azurerm_policy_definition.enforce_owner_tag.id
  scope                = "/subscriptions/${var.subscription_id}"
}
```

#### Variables

```terraform
variable "subscription_id" {
  description = "The ID of the subscription where the policy will be assigned"
  type        = string
}
```

### Summary

By using Azure Policy, you can enforce that an `owner` tag is present on all resources. The policy can be created and assigned using either Azure CLI or Terraform. The policy ensures that if the `owner` tag is missing, it will be automatically added with the value set to the user who created the resource.
