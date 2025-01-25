terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.11.0, < 4.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "terraform_azure_providers" {
  name     = "terraform_azure_providers"
  location = "East US"
}

module "network" {
  source              = "Azure/network/azurerm"
  version             = ">= 2.1.0" # Pin the module version
  resource_group_name = azurerm_resource_group.terraform_azure_providers.name
  subnet_prefixes     = ["10.0.1.0/24"]
  subnet_names        = ["subnet1"]

  use_for_each = false

  depends_on = [azurerm_resource_group.terraform_azure_providers]
}

module "linuxservers" {
  source              = "Azure/compute/azurerm"
  version             = "3.2.0" # Pin the module version
  resource_group_name = azurerm_resource_group.terraform_azure_providers.name
  vm_os_simple        = "UbuntuServer"
  public_ip_dns       = ["linsimplevmip"] # List with one string
  vnet_subnet_id      = module.network.vnet_subnets["subnet1"] # Map key reference
  vm_size             = "Standard_B1ls"
  depends_on          = [azurerm_resource_group.terraform_azure_providers]
}

output "linux_vm_public_name" {
  value = module.linuxservers.public_ip_dns # Correct attribute name
}