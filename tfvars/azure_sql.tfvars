sql = {
  mbf-rms = {
    resource_group_name           = "mahar"
    location                      = "southeastasia"
    administrator_login           = "mahar"
    administrator_password        = "mbf@123!"
    version                       = "12.0"
    public_network_access_enabled = true

    databases = {
      RMS_Grey_Production = {
        sku_name                    = "GP_S_Gen5_4"
        max_size_gb                 = 200
        collation                   = "SQL_Latin1_General_CP1_CI_AS"
        min_capacity                = 0.75
        auto_pause_delay_in_minutes = 300
      }
    }
  }
}