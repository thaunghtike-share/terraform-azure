# Map of Linux VMs to create
linux_vms = {
  outline = {
    name                  = "outline"
    location              = "southeastasia"
    resource_group_name   = "mahar"
    zone                  = "1"
    size                  = "Standard_B2s"
    admin_username        = "ubuntu"
    disable_password_auth = false
    secure_boot_enabled   = true
    vtpm_enabled          = true

    os_disk = {
      name                 = "outline_OsDisk_1_b5a4e77b878440fe8a4a94cefb3d5615"
      caching              = "ReadWrite"
      storage_account_type = "Premium_LRS"
    }

    source_image_reference = {
      publisher = "canonical"
      offer     = "ubuntu-24_04-lts"
      sku       = "server"
      version   = "latest"
    }

    ultra_ssd_enabled = false
  }

  mongo_primary = {
    name                  = "mongo-primary"
    resource_group_name   = "mahar"
    location              = "southeastasia"
    zone                  = "1"
    size                  = "Standard_B2s"
    admin_username        = "ubuntu"
    disable_password_auth = true
    secure_boot_enabled   = true
    vtpm_enabled          = true

    os_disk = {
      name                 = "mongo-primary_disk1_faa47f24a42e48fcaf522f7cb941b2bd"
      caching              = "ReadWrite"
      storage_account_type = "Premium_LRS"
      disk_size_gb         = 64
    }

    source_image_reference = {
      publisher = "canonical"
      offer     = "ubuntu-24_04-lts"
      sku       = "server"
      version   = "latest"
    }

    ultra_ssd_enabled = false

    admin_ssh_key = {
      username   = "ubuntu"
      public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCuMluwnUjVUHjbx7CE3tejc7jdWOqGYe2CsU36IL/K6IFEV4tLF+wUFyh1VCcjs9WiKuwDzF+WjlPApOd5IsxtSbuyM1/Rq+e9tVMiYY6stG2BvdsfUfxv2SOlbGqzPEZFl/2e6pQadxma22QfeDcJZsFQY/r4p8qgHt4IN01zKBKBO4en7PDHOOKx98J3g9tFU9xusVn5lrCphTPdQpJqvwM+C3ayTdZPDIFbQf/SN2sZ9HS7inyO1sCEgXTsHOvEHPbK1W6rB1I/P7Gs5hacnq4EZM0rfJA355YFTbxuv/OeOrtv8DprMPm6TMw3Ci8zdxPPFj58ONqZwe+QSE/DLs7qcjIgOTU+oloHC/2dMpCGOUdOctfdtYPOAlQ8+rT3coebxm46I+KfEPmwFPjo1kaSYBkrAeRWquLekQj8ZE8OSIgEUx3O+GlRQXYJ85e7c84Ei1SEfgaVuMqFUobqvvZS/E/LtjD/T2du5rUro5vEvNNbPqDYIn0t02HCycE= generated-by-azure"
    }
  }

  mongo_replica = {
    name                  = "mongo-replica"
    location              = "southeastasia"
    resource_group_name   = "mahar"
    zone                  = "1"
    size                  = "Standard_B1s"
    admin_username        = "ubuntu"
    disable_password_auth = true
    secure_boot_enabled   = true
    vtpm_enabled          = true

    os_disk = {
      name                 = "mongo-replica_OsDisk_1_958e5718f4974687995a6ebefadefba0"
      caching              = "ReadWrite"
      storage_account_type = "Premium_LRS"
    }

    source_image_reference = {
      publisher = "canonical"
      offer     = "ubuntu-24_04-lts"
      sku       = "server"
      version   = "latest"
    }

    ultra_ssd_enabled = false

    admin_ssh_key = {
      username   = "ubuntu"
      public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC/nROCoEx+sACcK3SyqDa5gbWvCbIvaQMK8LXn1Hy525xFcXfxVKnRwspfPre9VwnGMotDJ4rHzZgDCRRiR/r1i0mV2U5jlw41UrRb0xR8rQqQtQzt1hyu770RVBsxxHOsc/xfE34ooruZ1Z7nBdG9PukuBqcIZXhi9zR51y0CXjgIUhYqdJpqyj1MlS9JUuNgujfdJSKgblEHKtYK366gq6x2qgdSd8UaAV1NT1yVfgJ8xeRG2ja95HGNm1oc708pOZAnYFlsTYFDQoo3FG8l6Z/OrLVXfz1tEvXjISsezq6GzOADAXOa9/25nKEeFy5pLF9YlaHcdfUuVjHYjcwBV8NhBF+5EfVf5ktcoL2lp1gRTeRrBo1dkojgA47EEKri5wZvbHtBDiRRt1oD+j6k9sCs0xA7IAsHfQogN1BXIn3u+VmpShSzKOCDBd92iFFcg7+q/yy3gPJqytgkT3oCWiFazexlpA/01hhegKt3TDTJAEWGPeLfNVrYMwR51Tk= generated-by-azure"
    }
  }
}