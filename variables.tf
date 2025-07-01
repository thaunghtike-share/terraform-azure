variable "resource_groups" {
  description = "Map of resource groups to create and their locations"
  default     = {}
}

variable "vnets" {
  description = "Map of virtual networks and subnets. Each entry includes name, location, address space, and subnet map."
  default     = {}
}

variable "nsgs" {
  description = "Map of NSGs with rules. Each includes name, location, and rule definitions."
  default     = {}
}

variable "public_ips" {
  description = "Map of public IPs with name, location, allocation method, SKU, and zones."
  default     = {}
}

variable "nics" {
  description = "Map of NICs with references to VNets, subnets, public IPs, and optional NSG."
  default     = {}
}

variable "linux_vms" {
  description = "Map of Linux VMs with size, zone, image reference, OS disk, and SSH settings."
  default     = {}
}

variable "storage_accounts" {
  description = "Map of storage accounts with tier, replication type, and other settings."
  default     = {}
}

variable "nat_gateways" {
  description = "Map of NAT gateways with location, SKU, timeout, and public IP reference."
  default     = {}
}


variable "sql" {
  description = "Map of Azure SQL servers and their related Azure Databases. Each entry includes server name, location, resource group, version, administrator login, and database configurations."
  default     = {}
}

variable "aks_clusters" {
  description = "Map of AKS clusters to create"
  default     = {}
}

variable "acr_registries" {
  description = "Map of Azure Container Registries to create"
  default     = {}
}