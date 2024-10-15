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