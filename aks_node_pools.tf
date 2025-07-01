resource "azurerm_kubernetes_cluster_node_pool" "this" {
  for_each = {
    for pair in flatten([
      for cluster_key, cluster_value in var.aks_clusters : [
        for pool_key, pool in lookup(cluster_value, "node_pools", {}) : {
          pool_key              = "${cluster_key}_${pool_key}"
          cluster_name          = cluster_key
          resource_group_name   = cluster_value.resource_group_name
          kubernetes_cluster_id = azurerm_kubernetes_cluster.this[cluster_key].id
          name                  = pool_key
          vm_size               = pool.vm_size
          vnet_subnet_id        = azurerm_subnet.subnets["${pool.vnet_key}_${pool.subnet_key}"].id
          os_type               = lookup(pool, "os_type", "Linux")
          os_sku                = lookup(pool, "os_sku", "Ubuntu")
          mode                  = lookup(pool, "mode", "User")
          zones                 = lookup(pool, "zones", null)
          priority              = lookup(pool, "priority", "Regular")
          eviction_policy       = lookup(pool, "priority", "Regular") == "Spot" ? lookup(pool, "eviction_policy", "Delete") : null
          spot_max_price        = lookup(pool, "priority", "Regular") == "Spot" ? lookup(pool, "spot_max_price", null) : null
          enable_node_public_ip = lookup(pool, "enable_node_public_ip", false)
          enable_auto_scaling   = lookup(pool, "enable_auto_scaling", true)
          min_count             = lookup(pool, "enable_auto_scaling", true) ? pool.min_count : null
          max_count             = lookup(pool, "enable_auto_scaling", true) ? pool.max_count : null
          node_count            = lookup(pool, "enable_auto_scaling", true) ? null : lookup(pool, "node_count", 1)
          max_pods              = lookup(pool, "max_pods", 110)
          orchestrator_version  = lookup(pool, "orchestrator_version", null)
          node_taints           = lookup(pool, "taints", [])
          max_surge             = lookup(pool, "max_surge", "33%")
          tags                  = lookup(pool, "tags", null)
        }
      ]
    ]) : pair.pool_key => pair
  }

  name                  = each.value.name
  kubernetes_cluster_id = each.value.kubernetes_cluster_id
  vm_size               = each.value.vm_size
  os_type               = each.value.os_type
  os_sku                = each.value.os_sku
  mode                  = each.value.mode
  zones                 = each.value.zones
  priority              = each.value.priority
  eviction_policy       = each.value.eviction_policy
  spot_max_price        = each.value.spot_max_price
  node_taints           = each.value.node_taints

  enable_node_public_ip = each.value.enable_node_public_ip
  enable_auto_scaling   = each.value.enable_auto_scaling
  min_count             = each.value.min_count
  max_count             = each.value.max_count
  node_count            = each.value.node_count
  max_pods              = each.value.max_pods
  orchestrator_version  = each.value.orchestrator_version
  vnet_subnet_id        = each.value.vnet_subnet_id

  dynamic "upgrade_settings" {
    for_each = each.value.priority == "Spot" ? [] : [1]
    content {
      max_surge = each.value.max_surge
    }
  }

  tags = each.value.tags
}