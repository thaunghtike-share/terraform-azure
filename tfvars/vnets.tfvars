# vnets and subnets configuration for Azure resources
vnets = {
  mahar_vnet = {
    name                = "mahar-vnet"
    address_space       = ["10.224.0.0/12"]
    resource_group_name = "mahar"
    location            = "southeastasia"
    subnets = {
      default = {
        resource_group_name = "mahar"
        address_prefix      = "10.224.0.0/16"
        service_endpoints   = ["Microsoft.ContainerRegistry", "Microsoft.Sql"]
      }
    }
  }

  outline_vnet = {
    name                = "outline-vnet"
    address_space       = ["10.55.0.0/16"]
    resource_group_name = "mahar"
    location            = "southeastasia"
    subnets = {
      default = {
        resource_group_name = "mahar"
        address_prefix      = "10.55.1.0/24"
      }
    }
  }
}