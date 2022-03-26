# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.26"
    }
  }
  backend "azurerm" {
    resource_group_name   = "RG_Group4_week3_20220321"
    storage_account_name = "bitotfstate"
    container_name = "tfstate"
    access_key = "3GRCX3ihIRlXDhqOPJR7yMGf+6MUC3JJNWt4Y7F5dPJqy7Dg2ycuJj4rWb8EDZ0dxQdOJWYIcHSMZ0rYexoHgQ=="
}
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  subscription_id = "54d87296-b91a-47cd-93dd-955bd57b3e9a"
}


locals {
  primary_location_formatted   = replace(lower(var.primary_location), " ", "")
  secondary_location_formatted = replace(lower(var.secondary_location), " ", "")

  app_service_name_primary   = "${var.app_service_name}-${local.primary_location_formatted}"
  app_service_name_secondary = "${var.app_service_name}-${local.secondary_location_formatted}"

  app_service_plan_name_primary   = "${var.app_service_plan_name}-${local.primary_location_formatted}"
  app_service_plan_name_secondary = "${var.app_service_plan_name}-${local.secondary_location_formatted}"

  app_service_application_insights_name_primary   = "${var.app_service_application_insights_name}-${local.primary_location_formatted}"
  app_service_application_insights_name_secondary = "${var.app_service_application_insights_name}-${local.secondary_location_formatted}"

  subscription_id       = data.azurerm_subscription.current.subscription_id
  primary_endpoint_id   = "/subscriptions/${local.subscription_id}/resourceGroups/${azurerm_resource_group.rg.name}/providers/Microsoft.Web/sites/${local.app_service_name_primary}"
  secondary_endpoint_id = "/subscriptions/${local.subscription_id}/resourceGroups/${azurerm_resource_group.rg.name}/providers/Microsoft.Web/sites/${local.app_service_name_secondary}"
}

# Configure Resource Group
resource "azurerm_resource_group" "RG_Group4_week3_20220321" {
  name     = var.resource_group_name
  location = "Southeast Asia"
}

# Configure CosmosDB
module "cosmosdb" {
  source = "./modules/azure-cosmosdb"

  resource_group_name = "RG_Group4_week3_20220321"
  primary_location    = var.primary_location
  secondary_location  = var.secondary_location
  account_name        = var.cosmosdb_account_name
}

# Configure Azure App Service
# Primary region app service
module "app_service_primary" {
  source = "./modules/azure-app-service"

  resource_group_name = "RG_Group4_week3_20220321"
  location            = var.primary_location

  app_service_plan_name     = local.app_service_plan_name_primary
  app_service_plan_sku      = var.app_service_plan_sku
  application_insights_name = local.app_service_application_insights_name_primary
  app_service_name          = local.app_service_name_primary
  application_settings = {
    "cosmosdb_endpoint" : module.cosmosdb.endpoint
  }
}

# Secondary region app service (only deployed if its a secondary deployment)
module "app_service_secondary" {
  source = "./modules/azure-app-service"
  count  = var.is_primary_deployment ? 0 : 1

  resource_group_name = "RG_Group4_week3_20220321"
  location            = var.secondary_location

  app_service_plan_name     = local.app_service_plan_name_secondary
  app_service_plan_sku      = var.app_service_plan_sku
  application_insights_name = local.app_service_application_insights_name_secondary
  app_service_name          = local.app_service_name_secondary
  application_settings = {
    "cosmosdb_endpoint" : module.cosmosdb.endpoint
  }
}

# Configure Azure Traffic Manager Profile
module "traffic_manager_profile" {
  source = "./modules/azure-traffic-manager"
  depends_on = [
    module.app_service_primary
  ]

  resource_group_name = "RG_Group4_week3_20220321"
  profile_name        = var.traffic_manager_profile_name
}

module "primary_endpoint" {
  source = "./modules/azure-traffic-manager-endpoint"
  depends_on = [
    module.traffic_manager_profile
  ]

  resource_group_name = "RG_Group4_week3_20220321"
  name                = "primary_endpoint"
  profile_name        = var.traffic_manager_profile_name
  endpoint_id         = local.primary_endpoint_id
  priority            = 1
}

module "secondary_endpoint" {
  source = "./modules/azure-traffic-manager-endpoint"
  count  = var.is_primary_deployment ? 0 : 1
  depends_on = [
    module.app_service_secondary,
  ]

  resource_group_name = "RG_Group4_week3_20220321"
  name                = "secondary_endpoint"
  profile_name        = var.traffic_manager_profile_name
  endpoint_id         = local.secondary_endpoint_id
  priority            = 2
}
