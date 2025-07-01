locals {
  subnet_map = merge(
    [
      for vnet_key, vnet in var.vnets : {
        for subnet_key, subnet in vnet.subnets : "${vnet_key}_${subnet_key}" => {
          vnet_key            = vnet_key
          vnet_name           = vnet.name
          subnet_name         = subnet_key
          resource_group_name = subnet.resource_group_name
          address_prefix      = subnet.address_prefix
          service_endpoints   = lookup(subnet, "service_endpoints", [])
        }
      }
    ]...
  )
}

# Example of how `subnet_map` value should be 
# {
#   "mahar_vnet_default" = {
#     vnet_key            = "mahar_vnet"
#     vnet_name           = "mahar-vnet"
#     subnet_name         = "default"
#     resource_group_name = "mahar"
#     address_prefix      = "10.224.0.0/16"
#     service_endpoints   = ["Microsoft.ContainerRegistry", "Microsoft.Sql"]
#   }
#
#   "outline_vnet_default" = {
#     vnet_key            = "outline_vnet"
#     vnet_name           = "outline-vnet"
#     subnet_name         = "default"
#     resource_group_name = "mahar"
#     address_prefix      = "10.55.1.0/24"
#     service_endpoints   = []
#   }
# }