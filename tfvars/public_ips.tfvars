## Public IP configurations for VMs
public_ips = {
  mongo-primary-ip = {
    resource_group    = "mahar"
    location          = "southeastasia"
    allocation_method = "Static"
    sku               = "Standard"
    zones             = ["1"]
  }

  mongo-replica-ip = {
    resource_group    = "mahar"
    location          = "southeastasia"
    allocation_method = "Static"
    sku               = "Standard"
    zones             = ["1"]
  }

  mssql-ip = {
    resource_group    = "mahar"
    location          = "southeastasia"
    allocation_method = "Static"
    sku               = "Standard"
    zones             = ["1"]
  }

  outline-ip = {
    resource_group    = "mahar"
    location          = "southeastasia"
    allocation_method = "Static"
    sku               = "Standard"
    zones             = ["1"]
  }

  MyAKSNatGatewayIP = {
    resource_group    = "mahar"
    location          = "southeastasia"
    allocation_method = "Static"
    sku               = "Standard"
    zones             = []
  }
}