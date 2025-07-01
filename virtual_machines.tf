resource "azurerm_linux_virtual_machine" "linux_vms" {
  for_each = var.linux_vms

  name                            = each.value.name
  resource_group_name             = each.value.resource_group_name
  location                        = each.value.location
  size                            = each.value.size
  admin_username                  = each.value.admin_username
  disable_password_authentication = each.value.disable_password_auth
  secure_boot_enabled             = each.value.secure_boot_enabled
  vtpm_enabled                    = each.value.vtpm_enabled
  zone                            = each.value.zone

  admin_password = (
    each.value.disable_password_auth == false && try(each.value.admin_password, null) != null
    ? each.value.admin_password
    : null
  )

  network_interface_ids = [
    azurerm_network_interface.nics[each.key].id
  ]

  os_disk {
    name                 = each.value.os_disk.name
    caching              = each.value.os_disk.caching
    storage_account_type = each.value.os_disk.storage_account_type
  }

  source_image_reference {
    publisher = each.value.source_image_reference.publisher
    offer     = each.value.source_image_reference.offer
    sku       = each.value.source_image_reference.sku
    version   = each.value.source_image_reference.version
  }

  additional_capabilities {
    ultra_ssd_enabled = each.value.ultra_ssd_enabled
  }

  dynamic "admin_ssh_key" {
    for_each = try(each.value.admin_ssh_key != null ? [each.value.admin_ssh_key] : [], [])
    content {
      username   = admin_ssh_key.value.username
      public_key = admin_ssh_key.value.public_key
    }
  }

  boot_diagnostics {}

  tags = lookup(each.value, "tags", {})

  depends_on = [
    azurerm_resource_group.this,
    azurerm_network_interface.nics
  ]
}