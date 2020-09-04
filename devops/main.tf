provider "azurerm" {
  version = "~> 2.0"
  features {}
}

variable "sql_creds" {
  type = object({
    login    = string
    password = string
  })
  default = {
    login    = "hasura"
    password = "Pa$sw0rd"
  }
}

variable "app_name" {
  default = "hazurea"
}

variable "port" {
  default = 80
}

resource "azurerm_resource_group" "this" {
  name     = var.app_name
  location = "West US"
}

module "postgresql" {
  source = "./modules/az-postgresql"

  name           = var.app_name
  sql_creds      = var.sql_creds
  resource_group = azurerm_resource_group.this
}

resource "azurerm_container_group" "this" {
  name                = var.app_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  os_type             = "Linux"
  dns_name_label      = var.app_name

  container {
    name   = "hasura-graphql-engine"
    image  = "hasura/graphql-engine"
    cpu    = "1"
    memory = "1"
    ports {
      port     = var.port
      protocol = "TCP"
    }
    environment_variables = {
      HASURA_GRAPHQL_SERVER_PORT    = var.port
      HASURA_GRAPHQL_ENABLE_CONSOLE = "true"
    }
    secure_environment_variables = {
      HASURA_GRAPHQL_DATABASE_URL = module.postgresql.db_url
    }
  }
}

output "db_url" {
  value = module.postgresql.db_url
}

output "hasura_console_url" {
  # http://<dns-name-label>.westus.azurecontainer.io/console
  value = "http://${azurerm_container_group.this.fqdn}/console"
}
