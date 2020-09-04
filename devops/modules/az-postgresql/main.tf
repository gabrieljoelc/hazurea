# ported from https://hasura.io/docs/1.0/graphql/core/deployment/deployment-guides/azure-container-instances-postgres.html

variable "name" {
  type = string
}

variable "sql_creds" {
  type = object({
    login   = string
    password = string
  })
}

variable "resource_group" {
  type = object({
    name     = string
    location = string
  })
}

output "db_url" {
  # postgres://hasura%40<server_name>:<server_admin_password>@<hostname>:5432/hasura
  # %40 is used in the username because Azure creates usernames as
  # admin-user@server-name and since the database url uses @ to separate
  # username-password from hostname, we need to url-escape it in the username.
  # any other special character should be url-encoded.

  value = "postgres://${var.sql_creds.login}%40${azurerm_postgresql_server.this.name}:${var.sql_creds.password}@${azurerm_postgresql_server.this.fqdn}:5432/${var.name}"
}

resource "azurerm_postgresql_server" "this" {
  name                = var.name
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name

  administrator_login          = var.sql_creds.login
  administrator_login_password = var.sql_creds.password

  # https://docs.microsoft.com/en-us/azure/postgresql/concepts-pricing-tiers
  sku_name   = "B_Gen5_2"
  version    = "11"
  storage_mb = 5120

  ssl_enforcement_enabled          = true
  ssl_minimal_tls_version_enforced = "TLS1_2"
}

resource "azurerm_postgresql_firewall_rule" "this" {
  name                = var.name
  resource_group_name = var.resource_group.name
  server_name         = azurerm_postgresql_server.this.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_postgresql_database" "this" {
  name                = var.name
  resource_group_name = var.resource_group.name
  server_name         = azurerm_postgresql_server.this.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}
