resource "azurerm_resource_group" "this" {
  for_each = var.resource_groups

  name     = each.key
  location = each.value.location

  tags = lookup(each.value, "tags", {})

}