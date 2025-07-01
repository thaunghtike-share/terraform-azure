resource "azurerm_network_interface" "nics" {
  for_each = var.nics

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  ip_configuration {
    name                          = "ipconfig1"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.subnets["${each.value.vnet_key}_${each.value.subnet_key}"].id

    public_ip_address_id = try(
      azurerm_public_ip.public_ips[each.value.public_ip_key].id,
      null
    )
  }

  depends_on = [
    azurerm_public_ip.public_ips,
    azurerm_resource_group.this
  ]
}

resource "azurerm_network_interface_security_group_association" "nics_nsg_association" {
  for_each = var.nics

  network_interface_id      = azurerm_network_interface.nics[each.key].id
  network_security_group_id = azurerm_network_security_group.nsgs[each.key].id

  depends_on = [
    azurerm_network_security_group.nsgs
  ]
}
