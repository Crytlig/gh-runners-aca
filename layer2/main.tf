data "azurerm_resource_group" "rg" {
  name = "${local.stack}-rg"
}

data "azurerm_container_registry" "acr" {
  resource_group_name = data.azurerm_resource_group.rg.name
  name                = replace("${local.stack}acr", "-", "")
}

resource "azurerm_user_assigned_identity" "mi" {
  name                = "cry-dev-mi"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  tags                = local.default_tags
}

resource "azurerm_role_assignment" "ra" {
  scope                = data.azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.mi.principal_id
  depends_on = [
    azurerm_user_assigned_identity.mi
  ]
}

resource "azurerm_container_app_environment" "cae" {
  name                = "${local.stack}-cae"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  tags                = local.default_tags
}

resource "azurerm_container_app" "ca" {
  name                         = "${local.stack}-ca"
  container_app_environment_id = azurerm_container_app_environment.cae.id
  resource_group_name          = data.azurerm_resource_group.rg.name
  revision_mode                = "Single"

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.mi.id]
  }


  registry {
    server   = data.azurerm_container_registry.acr.login_server
    identity = azurerm_user_assigned_identity.mi.id
  }

  template {
    container {
      name   = "ca"
      image  = "${data.azurerm_container_registry.acr.login_server}/${var.container_image}:${var.container_tag}"
      cpu    = 0.25
      memory = "0.5Gi"
      # env {
      # blabla = ""
      # }

    }
    # https://techcommunity.microsoft.com/t5/fasttrack-for-azure/can-i-create-an-azure-container-apps-in-terraform-yes-you-can/ba-p/3570694
    # dynamic "" {
    #
    # }
    min_replicas = 0
  }

  tags = local.default_tags
}

