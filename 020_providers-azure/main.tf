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
  subscription_id = "8d620ffe-f57d-4b15-b5b8-7acff17b1869"
}

resource "azurerm_resource_group" "terraform_azure_providers" {
  name     = "terraform_azure_providers"
  location = "East US"
}

module "network" {
  source              = "Azure/network/azurerm"
  resource_group_name = azurerm_resource_group.terraform_azure_providers.name
  subnet_prefixes     = ["10.0.1.0/24"]
  subnet_names        = ["subnet1"]
  use_for_each        = false

  depends_on = [azurerm_resource_group.terraform_azure_providers]
}

module "linuxservers" {
  source              = "Azure/compute/azurerm"
  resource_group_name = azurerm_resource_group.terraform_azure_providers.name
  vm_os_simple        = "UbuntuServer"
  public_ip_dns = ["linsimplevmips"] # Unique name for the public IP
  vnet_subnet_id      = module.network.vnet_subnets[0]

  depends_on = [azurerm_resource_group.terraform_azure_providers]
}

module "windowsservers" {
  source              = "Azure/compute/azurerm"
  resource_group_name = azurerm_resource_group.terraform_azure_providers.name
  is_windows_image    = true
  vm_hostname         = "mywinvm"
  admin_password      = "ComplxP@ssw0rd!"
  vm_os_simple        = "WindowsServer"
  public_ip_dns = ["winsimplevmips"] # Unique name for the public IP
  vnet_subnet_id      = module.network.vnet_subnets[0]
  depends_on = [azurerm_resource_group.terraform_azure_providers]
}