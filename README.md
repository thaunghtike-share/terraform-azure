
## Azure Terraform Infrastructure Module

### ✨ Features

* Modular Azure infrastructure provisioning  
* Supports:
  * Resource Groups  
  * Virtual Network and Subnet  
  * Network Security Group and rules  
  * Public IP  
  * Network Interface  
  * NAT Gateway  
  * Linux Virtual Machines  
  * Azure SQL Server & Database  
  * Azure Storage  
  * Azure Kubernetes Service (AKS)  
* Uses `vnet_key` / `subnet_key` pattern for subnet reference  

### 🛠️ Prerequisites

* [Terraform](https://www.terraform.io/downloads.html) v1.2+  
* Azure CLI authenticated or environment variables configured  

### 🚀 Quick Start

```hcl
provider "azurerm" {
  features {}
}

module "infra" {
  source = "./terraform-azurerm"

  resource_groups = {
    dev = {
      location = "southeastasia"
    }
  }

  vnets = {
    my_vnet = {
      name                = "my-vnet"
      location            = "southeastasia"
      resource_group_name = "dev"
      address_space       = ["10.0.0.0/16"]

      subnets = {
        default = {
          resource_group_name = "dev"
          address_prefix      = "10.0.1.0/24"
        }
      }
    }
  }

  # Define public_ips, nics, linux_vms, nat_gateways, etc. as needed
}
```

### 🌐 VNet/Subnet Mapping: `vnet_key` and `subnet_key`

This module uses a dynamic and consistent pattern to reference subnets across multiple VNets using two keys:

* `vnet_key`: identifies the virtual network  
* `subnet_key`: identifies the subnet inside that VNet  

The combined key format is:

```hcl
"${vnet_key}_${subnet_key}"
```

Used as:

```hcl
azurerm_subnet.subnets["${vnet_key}_${subnet_key}"]
```

## 📦 Why This Pattern?

Using `vnet_key` and `subnet_key`:

* Provides **clear, unique identifiers** for each subnet  
* Enables **clean for_each loops** for modular resource creation  
* Avoids duplication and hardcoding of VNet and subnet names  
* Makes the module compatible with **multiple resources** like:  
  * NAT Gateway associations  
  * NIC subnet bindings  
  * Route tables, NSGs, etc.  


## 🧱️ Key Definitions

You combine these two keys using an underscore (_) to form a unique identifier string. If vnet_key is "main_vnet" and subnet_key is "default", then the combined key is:

```hcl
azurerm_subnet.subnets["main_vnet_default"]
```

## Where Do These Keys Come From?

Defined as the key in your top-level vnets map input variable.

### `vnet_key`

The key in the top-level `vnets` map input.

```hcl
vnets = {
  main_vnet = {             # <- This is the vnet_key
    name                = "main-vnet"
    location            = "eastus"
    resource_group_name = "rg-example"
    address_space       = ["10.1.0.0/16"]
    subnets             = {
      # subnet definitions here
    }
  }
  secondary_vnet = {        # <- Another vnet_key
    name                = "secondary-vnet"
    # ...
  }
}
```

### `subnet_key`

The key in the `subnets` map under each VNet block.

```hcl
subnets = {
  default = {              # <- This is the subnet_key
    address_prefix      = "10.1.0.0/24"
    resource_group_name = "rg-example"
  }
  backend = {              # <- Another subnet_key
    address_prefix      = "10.1.1.0/24"
  }
}
```
---

## 💡 Combined Key Example

```hcl
azurerm_subnet.subnets["main_vnet_default"].id
```

Means:

* `vnet_key = "main_vnet"`  
* `subnet_key = "default"`  

## Terraform Import: VNet and Subnet

You want to import your existing vnet named my-vnet and subnet using this module.

```hcl

module "infra" {
  source = "./terraform-azurerm"

  vnets = {
    my_vnet = {
      name                = "my-vnet"
      location            = "southeastasia"
      resource_group_name = "dev"
      address_space       = ["10.0.0.0/16"]

      subnets = {
        default = {
          resource_group_name = "dev"
          address_prefix      = "10.0.1.0/24"
        }
      }
    }
  }
}
```

Assuming your existing Azure resource group is named dev, and the virtual network is named my-vnet with a subnet named default:

## Import Command

```hcl
terraform import module.infra.azurerm_virtual_network.vnets["my_vnet"] /subscriptions/6f48750e-5037-4321-9d8b-a9e58c87accf/resourceGroups/dev/providers/Microsoft.Network/virtualNetworks/my-vnet

terraform import module.infra.azurerm_subnet.subnets["my_vnet_default"] /subscriptions/6f48750e-5037-4321-9d8b-a9e58c87accf/resourceGroups/dev/providers/Microsoft.Network/virtualNetworks/my-vnet/subnets/default
```

### NAT Gateway Association

```hcl
resource "azurerm_subnet_nat_gateway_association" "this" {
  for_each = var.nat_gateways

  subnet_id      = azurerm_subnet.subnets["${each.value.vnet_key}_${each.value.subnet_key}"].id
  nat_gateway_id = azurerm_nat_gateway.this[each.key].id
}
```

#### Input Example:

```hcl
nat_gateways = {
  demo_nat = {
    vnet_key   = "main_vnet"
    subnet_key = "default"
    # other nat gateway configs...
  }
}
```
### NIC Subnet Assignment

```hcl
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
}
```

#### Input Example:

```hcl
nics = {
  example_nic = {
    name                = "example-nic"
    location            = "southeastasia"
    resource_group_name = "dev"
    vnet_key            = "my_vnet"
    subnet_key          = "default"
    public_ip_key       = "example-public-ip"
  }
}
```

## 🔍 Summary

| Key          | Purpose                             |
| ------------ | ----------------------------------- |
| `vnet_key`   | Identifies the virtual network      |
| `subnet_key` | Identifies a subnet inside the VNet |

> This pattern keeps your infrastructure **modular**, **scalable**, and **reusable**.

## Additional Resources

* See `examples/` and `tfvars/` folders for complete variable files and usage.  

### 🔑 Shared Same Keys Between nics and nsgs

Both nics and nsgs use matching keys (e.g., "mongo_primary", "outline", etc.), and that's intentional:

- The NIC key identifies the network interface.
- The NSG key identifies the corresponding security group for that NIC.
- These keys are used to associate each NIC with its matching NSG in the azurerm_network_interface_security_group_association.

### 🧠 Why use the same keys?

By using the same logical key for NIC and NSG:

- You avoid duplication
- You can use the same loop (for_each = var.nics) to wire them together
- You make your module clean and consistent

> **Note:** When you define a NIC, you must also define an NSG using the **same key** to ensure proper association.  

> **Eg:** if you create a NIC with key `"outline"`, there should be a corresponding NSG with the same key `"outline"` in the `nsgs` map.

### 💡 Example: How It Works

```hcl
nics = {
  outline = {
    name                = "outline-nic"
    resource_group_name = "mahar"
    vnet_key            = "outline_vnet"
    subnet_key          = "default"
    public_ip_key       = "outline-ip"
  }
}

nsgs = {
  outline = {
    name           = "outline-nsg"
    location       = "southeastasia"
    resource_group = "mahar"
    rules          = { ... }
  }
}
```
 ### Association Logic

```hcl
resource "azurerm_network_interface_security_group_association" "nics_nsg_association" {
  for_each = var.nics

  network_interface_id      = azurerm_network_interface.nics[each.key].id
  network_security_group_id = azurerm_network_security_group.nsgs[each.key].id
}
```
➡️ So it links:

- `azurerm_network_interface.nics["outline"]`
- to `azurerm_network_security_group.nsgs["outline"]`

### New Aks Cluster Creation (Modular & Dynamic)

-  **aks.tf** is designed **to create new AKS clusters** from scratch.
- It is **modular, reusable, and parameterized** so you can deploy multiple clusters easily.
- Supports Azure Entra ID authentication, network profiles, node pools, etc.
- Allows cleaner lifecycle management and future scaling or upgrades.

```hcl
provider "azurerm" {
  features {}
}

module "infra" {
  source = "./terraform-azurerm"

  resource_groups = {
    dev = {
      location = "southeastasia"
    }
  }

  vnets = {
    myvnet = {
      name                = "myvnet"
      location            = "southeastasia"
      resource_group_name = "dev"
      address_space       = ["10.100.0.0/16"]

      subnets = {
        default = {
          resource_group_name = "dev"
          address_prefix      = "10.100.1.0/24"
        }
      }
    }
  }

  acr_registries = {
    myacrk8s12345 = {
      create              = true
      resource_group_name = "dev"
      location            = "southeastasia"
      sku                 = "Basic"
      admin_enabled       = true
    }
  }

  aks_clusters = {
    cluster1 = {
      location                     = "southeastasia"
      resource_group_name          = "dev"
      dns_prefix                   = "dev-dns1"
      kubernetes_version           = "1.32.3"
      sku_tier                     = "Free"
      image_cleaner_interval_hours = 168

      acr_key = "myacrk8s12345"

      default_node_pool = {
        name                  = "default"
        vm_size               = "Standard_A2_v2"
        os_sku                = "Ubuntu"
        zones                 = ["1", "2", "3"]
        enable_node_public_ip = true
        enable_auto_scaling   = true
        min_count             = 1
        max_count             = 2
        max_pods              = 110
        orchestrator_version  = "1.32.3"
        vnet_key              = "myvnet"
        subnet_key            = "default"
        max_surge             = "10%"
      }

      node_pools = {
        development = {
          vm_size               = "Standard_A2_v2"
          os_sku                = "Ubuntu"
          enable_auto_scaling   = true
          enable_node_public_ip = false
          min_count             = 1
          max_count             = 3
          max_pods              = 110
          priority              = "Spot"
          eviction_policy       = "Deallocate"
          spot_max_price        = -1
          orchestrator_version  = "1.32.3"
          vnet_key              = "myvnet"
          subnet_key            = "mysubnet"
          enable_node_public_ip = false
          zones                 = ["1"]
          max_surge             = "25%"
          taints = [
            "build=true:NoSchedule"
          ]
          tags = {
            environment = "development"
          }
        }
      }

      network_profile = {
        service_cidr              = "10.10.0.0/16"
        dns_service_ip            = "10.10.0.10"
        managed_outbound_ip_count = 1
      }
    }
  }
}
```
> - Notes: acr_key is optional. You can attach the ACR using acr_key. If you want to attach an existing ACR outside Terraform, you can import the existing ACR using terraform import. The role assignment for AKS to pull images from ACR will be handled automatically via a local-exec provisioner calling Azure CLI.

### Supporting Both Spot and Regular AKS Node Pools in Terraform

This Terraform configuration supports creating **both Spot and Regular VM priority node pools** within your Azure Kubernetes Service (AKS) cluster. You can specify the node pool priority as `"Spot"` or `"Regular"` in your input variables.

## Key Differences Between Spot and Regular Node Pools

| Feature              | Regular Node Pool       | Spot Node Pool                  |
|----------------------|------------------------|--------------------------------|
| VM Priority          | Regular                | Spot (low-cost, evictable)      |
| Eviction Policy       | Not applicable         | `"Delete"` or `"Deallocate"`    |
| Max Surge Upgrade     | Allowed (`max_surge`)   | **Not allowed by Azure**        |
| Spot Max Price        | Not applicable         | Optional, maximum price to pay  |

## Why Use a Dynamic Block for `upgrade_settings`

Azure **does not allow `max_surge` to be set on Spot node pools**. If you try to set it, you will get an error during deployment.

Therefore, in Terraform:

- **If the node pool is a Spot instance (`priority == "Spot"`), the `upgrade_settings` block is omitted entirely.**

- **If the node pool is Regular, the `upgrade_settings` block is included with `max_surge`.**

Terraform's `dynamic` block is used to conditionally include or exclude `upgrade_settings`:

```hcl
dynamic "upgrade_settings" {
  for_each = each.value.priority == "Spot" ? [] : [1]  # Omit for Spot pools
  content {
    max_surge = each.value.max_surge                    # Only for Regular pools
  }
}
```

### 🔧 Initialize

```bash
terraform init -backend-config="tfvars/backend.tfvars"
```

### Terraform Plan

```bash
terraform plan \
  -var-file="tfvars/vnets.tfvars" \
  -var-file="tfvars/nsgs.tfvars" \
  -var-file="tfvars/public_ips.tfvars" \
  -var-file="tfvars/nics.tfvars" \
  -var-file="tfvars/vms.tfvars" \
  -var-file="tfvars/storageaccounts.tfvars" \
  -var-file="tfvars/nat_gw.tfvars" \
  -var-file="tfvars/resource_gps.tfvars" \
  -var-file="tfvars/azure_sql.tfvars"
```

### Terraform Apply

```bash
terraform apply \
  -var-file="tfvars/vnets.tfvars" \
  -var-file="tfvars/nsgs.tfvars" \
  -var-file="tfvars/public_ips.tfvars" \
  -var-file="tfvars/nics.tfvars" \
  -var-file="tfvars/vms.tfvars" \
  -var-file="tfvars/storageaccounts.tfvars" \
  -var-file="tfvars/nat_gw.tfvars" \
  -var-file="tfvars/resource_gps.tfvars" \
  -var-file="tfvars/azure_sql.tfvars"
```
### 📦 Import Example

```bash
terraform import -var-file="tfvars/vnets.tfvars" \
  azurerm_virtual_network.vnets["main_vnet"] \
  /subscriptions/<subscription_id>/resourceGroups/<rg>/providers/Microsoft.Network/virtualNetworks/my-vnet
```

---

<!-- BEGIN_TF_DOCS -->
README.md updated successfully
<!-- END_TF_DOCS -->
