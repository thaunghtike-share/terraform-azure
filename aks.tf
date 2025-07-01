resource "azurerm_kubernetes_cluster" "this" {
  for_each = var.aks_clusters

  name                = each.key
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  sku_tier            = lookup(each.value, "sku_tier", "Free")

  dns_prefix         = each.value.dns_prefix
  kubernetes_version = each.value.kubernetes_version

  private_cluster_enabled = lookup(each.value, "private_cluster_enabled", false)
  private_dns_zone_id     = lookup(each.value, "private_dns_zone_id", null)

  oidc_issuer_enabled = true

  image_cleaner_enabled        = true
  image_cleaner_interval_hours = each.value.image_cleaner_interval_hours

  default_node_pool {
    name    = each.value.default_node_pool.name
    vm_size = each.value.default_node_pool.vm_size
    os_sku  = lookup(each.value.default_node_pool, "os_sku", "Ubuntu")
    type    = "VirtualMachineScaleSets"
    zones   = lookup(each.value.default_node_pool, "zones", null)

    enable_node_public_ip = lookup(each.value.default_node_pool, "enable_node_public_ip", true)
    enable_auto_scaling   = lookup(each.value.default_node_pool, "enable_auto_scaling", true)
    min_count             = lookup(each.value.default_node_pool, "enable_auto_scaling", true) ? each.value.default_node_pool.min_count : null
    max_count             = lookup(each.value.default_node_pool, "enable_auto_scaling", true) ? each.value.default_node_pool.max_count : null
    node_count            = lookup(each.value.default_node_pool, "enable_auto_scaling", true) ? null : lookup(each.value.default_node_pool, "node_count", 1)
    max_pods              = each.value.default_node_pool.max_pods
    orchestrator_version  = each.value.default_node_pool.orchestrator_version

    vnet_subnet_id = azurerm_subnet.subnets["${each.value.default_node_pool.vnet_key}_${each.value.default_node_pool.subnet_key}"].id

    upgrade_settings {
      max_surge = each.value.default_node_pool.max_surge
    }
  }

  azure_active_directory_role_based_access_control {
    managed            = lookup(each.value, "azure_active_directory_role_based_access_control_managed", true)
    azure_rbac_enabled = lookup(each.value, "azure_active_directory_role_based_access_control_azure_rbac_enabled", false)
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin      = lookup(each.value.network_profile, "network_plugin", "azure")
    network_plugin_mode = lookup(each.value.network_profile, "network_plugin_mode", "overlay")
    network_policy      = lookup(each.value.network_profile, "network_policy", "azure")
    load_balancer_sku   = lookup(each.value.network_profile, "load_balancer_sku", "standard")
    outbound_type       = lookup(each.value.network_profile, "outbound_type", "loadBalancer")
    pod_cidr            = lookup(each.value.network_profile, "pod_cidr", null) # not required for Azure CNI overlay mode
    service_cidr        = each.value.network_profile.service_cidr
    dns_service_ip      = each.value.network_profile.dns_service_ip

    load_balancer_profile {
      managed_outbound_ip_count = lookup(each.value.network_profile, "managed_outbound_ip_count", 1)
    }
  }

  api_server_access_profile {
    authorized_ip_ranges = lookup(each.value, "api_server_access_profile_authorized_ip_ranges", [])
  }

  depends_on = [
    azurerm_resource_group.this,
    azurerm_subnet.subnets
  ]
}