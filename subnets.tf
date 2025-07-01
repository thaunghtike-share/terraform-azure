resource "azurerm_subnet" "subnets" {
  for_each = local.subnet_map

  name                 = each.value.subnet_name
  resource_group_name  = each.value.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnets[each.value.vnet_key].name
  address_prefixes     = [each.value.address_prefix]
  service_endpoints    = each.value.service_endpoints

  depends_on = [
    azurerm_virtual_network.vnets
  ]
}
