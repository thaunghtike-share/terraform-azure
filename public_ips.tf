resource "azurerm_public_ip" "public_ips" {
  for_each = var.public_ips

  name                = each.key
  resource_group_name = each.value.resource_group
  location            = each.value.location
  allocation_method   = each.value.allocation_method
  sku                 = each.value.sku
  zones               = each.value.zones

  tags = lookup(each.value, "tags", {})

  depends_on = [
    azurerm_resource_group.this
  ]
}