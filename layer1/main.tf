resource "azurerm_resource_group" "rg" {
  name     = "${local.stack}-rg"
  location = var.region
  tags     = local.default_tags
}

resource "azurerm_container_registry" "acr" {
  name                = replace("${local.stack}acr", "-", "")
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true // experiment with this to use managed identity instead
  tags                = local.default_tags

  identity {
    type = "SystemAssigned"
  }
}

