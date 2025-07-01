resource "azurerm_container_registry" "this" {
  for_each = var.acr_registries

  name                = each.key
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  sku                 = lookup(each.value, "sku", "Basic")
  admin_enabled       = lookup(each.value, "admin_enabled", true)
}