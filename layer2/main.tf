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

resource "azapi_resource" "ca" {
  name     = "${local.stack}-ca"
  location = data.azurerm_resource_group.rg.location
  parent_id = data.azurerm_resource_group.rg.id
  type     = "Microsoft.App/containerApps@2023-04-01-preview"
  tags     = local.default_tags

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.mi.id]
  }

  body = jsonencode({
    properties = {
      managedEnvironmentId = azurerm_container_app_environment.cae.id
      configuration = {
        secrets = [
          {
            name = "token"
            value = var.github_token
          }
        ]
        registries = [
          {
            server = data.azurerm_container_registry.acr.login_server,
            identity = azurerm_user_assigned_identity.mi.id
          }
        ]
      }
      template = {
        containers = [
          {
            image = "${data.azurerm_container_registry.acr.login_server}/${var.container_image}:${var.container_tag}",
            name  = "ca"
            resources = {
              cpu    = 0.25
              memory = "0.5Gi"
            },
            env = [
              {
                name = "GH_OWNER"
                value = var.github_org
              },
              {
                name = "GH_REPOSITORY"
                value = var.github_repo
              },
              {
                secretRef = "token"
                name = "GH_TOKEN"
              },
            ]
          }
        ]
        scale = {
        minReplicas = 1,
        maxReplicas = 20,
        rules = [
          {
            custom = {
              auth = [
                {
                  secretRef = "token",
                  triggerParameter = "personalAccessToken"
                }
              ],
              metadata = {
                labels = "self-hosted",
                owner = var.github_org,
                repos = var.github_repo,
                runnerScope = "repo",
                targetWorkflowQueueLength = "1"
              },
              type = "github-runner"
            },
            name = "github"
          }
        ]
      },
      }
    }
  })
  ignore_missing_property = true
  depends_on = [
    azurerm_container_app_environment.cae
  ]
}