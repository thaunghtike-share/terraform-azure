# Map of storage accounts with resource group and settings
storage_accounts = {
  logsbyloki = {
    resource_group                   = "mahar"
    location                         = "southeastasia"
    account_tier                     = "Standard"
    account_replication_type         = "RAGRS"
    allow_nested_items_to_be_public  = false
    cross_tenant_replication_enabled = false
  }
  mahar = {
    resource_group                   = "mahar"
    location                         = "southeastasia"
    account_tier                     = "Standard"
    account_replication_type         = "RAGRS"
    allow_nested_items_to_be_public  = true
    cross_tenant_replication_enabled = false
  }
  mbfdbbackups = {
    resource_group                   = "mahar"
    location                         = "southeastasia"
    account_tier                     = "Standard"
    account_replication_type         = "RAGRS"
    allow_nested_items_to_be_public  = false
    cross_tenant_replication_enabled = false
  }
}