# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
  backend "azurerm" {
    resource_group_name   = "RG_Group4_week3_20220321"
    storage_account_name = "tfsaving"
    container_name = "tfstate"
    access_key = "WOvXumt8tGxwUHztaqtibcPzempbfyN1Q2aUzY4tMliMQBWQEMtpQLySJK/9016wICjra3l6lClQ911g2gBETg=="
}
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  subscription_id = "54d87296-b91a-47cd-93dd-955bd57b3e9a"
}