resource "azurerm_role_assignment" "aks_acr_pull" {
  for_each = {
    for k, v in var.aks_clusters : k => v
    if contains(keys(v), "acr_key") && v.acr_key != null && length(v.acr_key) > 0
  }

  scope                = azurerm_container_registry.this[each.value.acr_key].id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.this[each.key].kubelet_identity[0].object_id
}

# ------------------------------------------------------------------------------
# If azurerm_role_assignment fails to attach AKS -> ACR correctly, uncomment this.
# This uses Azure CLI to grant the AKS kubelet identity access to pull from ACR.
# ------------------------------------------------------------------------------

# resource "null_resource" "attach_acr" {
#   for_each = {
#     for k, v in var.aks_clusters : k => v
#     if contains(keys(v), "acr_key") && v.acr_key != null && length(v.acr_key) > 0
#   }

#   provisioner "local-exec" {
#     command = <<EOT
#       az role assignment create \
#         --assignee "$(az aks show -g ${each.value.resource_group_name} -n ${each.key} --query identityProfile.kubeletidentity.objectId -o tsv)" \
#         --role AcrPull \
#         --scope "$(az acr show -n ${each.value.acr_key} --query id -o tsv)"
#     EOT
#     interpreter = ["/bin/bash", "-c"]
#   }

#   depends_on = [
#     azurerm_kubernetes_cluster.this,
#     azurerm_container_registry.this
#   ]
# }