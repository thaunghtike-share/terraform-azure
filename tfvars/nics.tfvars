# Network interfaces (NICs) and NSG associations
nics = {
  outline = {
    name                = "outline123_z1"
    location            = "southeastasia"
    resource_group_name = "mahar"
    vnet_key            = "outline_vnet" # Reference to the VNet key from the `vnets` map (not the actual VNet name)
    subnet_key          = "default"      # Reference to the subnet key inside that VNet's `subnets` map (not the actual subnet name)
    public_ip_key       = "outline-ip"
  }

  mongo_primary = {
    name                = "mongo-primary359_z1"
    location            = "southeastasia"
    resource_group_name = "mahar"
    vnet_key            = "mahar_vnet"
    subnet_key          = "default"
    public_ip_key       = "mongo-primary-ip"
  }

  mongo_replica = {
    name                = "mongo-replica587_z1"
    location            = "southeastasia"
    resource_group_name = "mahar"
    vnet_key            = "mahar_vnet"
    subnet_key          = "default"
    public_ip_key       = "mongo-replica-ip"
  }

  mssql = {
    name                = "mssql841_z1"
    location            = "southeastasia"
    resource_group_name = "mahar"
    vnet_key            = "mahar_vnet"
    subnet_key          = "default"
    public_ip_key       = "mssql-ip"
  }
}