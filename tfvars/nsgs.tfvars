## Network Security Groups (NSGs) with rules
nsgs = {
  mongo_primary = {
    name           = "mongo-primary-nsg"
    location       = "southeastasia"
    resource_group = "mahar"
    rules = {
      SSH = {
        priority                   = 300
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        source_address_prefix      = "*"
        destination_port_range     = "22"
        destination_address_prefix = "*"
      }
      Redis = {
        priority                   = 310
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        source_address_prefix      = "*"
        destination_port_range     = "6379"
        destination_address_prefix = "*"
      }
      AllowAnyCustomAnyInbound = {
        priority                   = 320
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "*"
        source_port_range          = "*"
        source_address_prefix      = "*"
        destination_port_range     = "*"
        destination_address_prefix = "*"
      }
    }
  }

  mongo_replica = {
    name           = "mongo-replica-nsg"
    location       = "southeastasia"
    resource_group = "mahar"

    rules = {
      SSH = {
        priority                   = 300
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        source_address_prefix      = "*"
        destination_port_range     = "22"
        destination_address_prefix = "*"
      }
      AllowAnyCustomAnyInbound = {
        priority                   = 320
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "*"
        source_port_range          = "*"
        source_address_prefix      = "*"
        destination_port_range     = "*"
        destination_address_prefix = "*"
      }
    }
  }

  mssql = {
    name           = "mssql-nsg"
    location       = "southeastasia"
    resource_group = "mahar"

    rules = {
      SSH = {
        priority                   = 300
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        source_address_prefix      = "*"
        destination_port_range     = "22"
        destination_address_prefix = "*"
      }
      AllowAnyCustomAnyInbound = {
        priority                   = 310
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "*"
        source_port_range          = "*"
        source_address_prefix      = "*"
        destination_port_range     = "*"
        destination_address_prefix = "*"
      }
    }
  }

  outline = {
    name           = "outline-nsg"
    location       = "southeastasia"
    resource_group = "mahar"

    rules = {
      AllowAnyCustomAnyInbound = {
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "*"
        source_port_range          = "*"
        source_address_prefix      = "*"
        destination_port_range     = "*"
        destination_address_prefix = "*"
      }
      AllowAnySSHInbound = {
        priority                   = 110
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        source_address_prefix      = "*"
        destination_port_range     = "22"
        destination_address_prefix = "*"
      }
    }
  }
}