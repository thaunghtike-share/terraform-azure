resource "azurerm_mssql_server" "servers" {
  for_each = var.sql

  name                          = each.key
  resource_group_name           = each.value.resource_group_name
  location                      = each.value.location
  administrator_login           = each.value.administrator_login
  administrator_login_password  = each.value.administrator_password
  version                       = each.value.version
  public_network_access_enabled = lookup(each.value, "public_network_access_enabled", true)
  minimum_tls_version           = "1.2"

  tags = lookup(each.value, "tags", {})

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [administrator_login_password]
  }

  depends_on = [
    azurerm_resource_group.this
  ]
}

resource "azurerm_mssql_database" "databases" {
  for_each = merge([
    for server_key, server in var.sql : {
      for db_key, db in server.databases :
      "${server_key}_${db_key}" => {
        server_key = server_key
        db_key     = db_key
        db         = db
      }
    }
  ]...)

  name        = each.value.db_key
  server_id   = azurerm_mssql_server.servers[each.value.server_key].id
  sku_name    = try(each.value.db.sku_name, "GP_S_Gen5_2")
  max_size_gb = try(each.value.db.max_size_gb, 100)
  collation   = try(each.value.db.collation, "SQL_Latin1_General_CP1_CI_AS")

  min_capacity                = try(each.value.db.min_capacity, null)
  auto_pause_delay_in_minutes = try(each.value.db.auto_pause_delay_in_minutes, 60)

  tags = lookup(each.value, "tags", {})

  lifecycle {
    prevent_destroy = true
  }

  depends_on = [
    azurerm_resource_group.this
  ]
}