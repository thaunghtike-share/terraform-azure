resource "azurerm_nat_gateway" "this" {
  for_each = var.nat_gateways

  name                    = each.key
  resource_group_name     = each.value.resource_group_name
  location                = each.value.location
  sku_name                = each.value.sku_name
  idle_timeout_in_minutes = each.value.idle_timeout

  tags = lookup(each.value, "tags", {})

  depends_on = [
    azurerm_resource_group.this
  ]
}

resource "azurerm_nat_gateway_public_ip_association" "this" {
  for_each = var.nat_gateways

  nat_gateway_id       = azurerm_nat_gateway.this[each.key].id
  public_ip_address_id = azurerm_public_ip.public_ips[each.value.public_ip_key].id
}

resource "azurerm_subnet_nat_gateway_association" "this" {
  for_each = var.nat_gateways

  subnet_id      = azurerm_subnet.subnets["${each.value.vnet_key}_${each.value.subnet_key}"].id
  nat_gateway_id = azurerm_nat_gateway.this[each.key].id
}