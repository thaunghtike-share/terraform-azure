## 🚀 Initialize Terraform Backend

## Your backend configuration is provided via `backend.tfvars`:
resource_group_name  = "tfstate-rg"
storage_account_name = "mbftfstatestorage"
container_name       = "tfstate"
key                  = "mbf.terraform.tfstate"