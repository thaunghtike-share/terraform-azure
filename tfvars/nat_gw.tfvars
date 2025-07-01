# NAT Gateway and their public IP associations
nat_gateways = {
  aks-nat-gateway = {
    resource_group_name = "mahar"
    location            = "southeastasia"
    sku_name            = "Standard"
    idle_timeout        = 4
    public_ip_key       = "MyAKSNatGatewayIP"
    vnet_key            = "mahar_vnet"
    subnet_key          = "default"
  }
}