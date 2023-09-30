terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.74.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg_backend_tfstate"
    storage_account_name = "sabetfsfztzkj"
    container_name       = "tfstate"
    key                  = "${var.backend_key}.terraform.tfstate"
  }
}

locals {
    workspaces_suffix = terraform.workspace == "default" ? "" : "${terraform.workspace}"
    rg_name = "VN-RG-${var.base_name}-${local.workspace_suffix}"
    location = var.location
}

resource "azurerm_resource_group" "vn-rg" {
  name     = local.rg_name
  location = local.location
}

resource "azurerm_network_security_group" "nsg" {
  name                = "NSG-${var.base_name}"
  location            =local.location
  resource_group_name = local.rg_name

   security_rule {
    name                       = "Allow-Public-IP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "158.248.1.71"
    destination_address_prefix = "*"
  }
}

resource "azurerm_virtual_network" "vnet" {
  name                = "VNET-${var.base_name}"
  location            = local.location
  resource_group_name = local.rg_name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]
}

resource "azurerm_subnet" "subnet01" {
  name                 = "subnet01-${var.base_name}"
  resource_group_name  = local.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet_network_security_group_association" "nsg-association" {
  subnet_id                 = azurerm_subnet.subnet01.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}