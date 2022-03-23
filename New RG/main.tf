locals {
  rg_name = "RG_Group4_week3_20220321"
  location_2 = "Australia Central"
}

# Resource Group
# --------------

resource "azurerm_resource_group" "RG_Group4_week3_20220321" {
  name     = "RG_Group4_week3_20220321"
  location = var.location
  tags = var.tags
}


# App Service Plan
# --------------
resource "azurerm_app_service_plan" "group4-plan" {
  name                = "group4-apps-plan"
  location            = local.location_2
  resource_group_name = azurerm_resource_group.RG_Group4_week3_20220321.name
  tags                = var.tags
  kind                = "Linux"
  reserved            = true # must be true for Linux

  sku {
    tier = "Standard"
    size = "S1"
  }
}


# App Service 
# --------------
resource "azurerm_app_service" "group4-app" {
  name                    = "group4-app"
  location                = "Australia Central"
  resource_group_name     = azurerm_resource_group.RG_Group4_week3_20220321.name
  app_service_plan_id     = azurerm_app_service_plan.group4-plan.id
  #https_only              = true
  #client_affinity_enabled = false
  tags                		= var.tags

 # site_config {
    
     
 #   }

 #   app_settings = {
 #     "SOME_KEY" = "some-value"
 #   }

 #   connection_string {
 #     name  = "Database"
 #     type  = "SQLServer"
 #     value = "Server=some-server.mydomain.com;Integrated Security=SSPI"
 # }
}


# Azure MySQL 
# --------------
#resource "azurerm_mysql_server" "SQL_Group4" {
#  name                = "group4-week3-mysqlserver"
#   location            = azurerm_resource_group.RG_Group4.location
#   resource_group_name = azurerm_resource_group.RG_Group4.name

#   administrator_login          = "group04"
#   administrator_login_password = "Group@04"

#   sku_name   = "B_Gen5_1" #cheapest
#   storage_mb = 5120 #smallest
#   version    = "5.7"

#   auto_grow_enabled                 = true
#   backup_retention_days             = 7
#   geo_redundant_backup_enabled      = false
#   infrastructure_encryption_enabled = false
#   public_network_access_enabled     = true
#   ssl_enforcement_enabled           = true
#   ssl_minimal_tls_version_enforced  = "TLS1_2"
# }


# resource "azurerm_mysql_database" "wordpress" {
#   name                = "Group4-week3-mysqlDB"
#   resource_group_name = azurerm_resource_group.RG_Group4.name
#   server_name         = azurerm_mysql_server.SQL_Group4.name
#   charset             = "utf8"
#   collation           = "utf8_unicode_ci"
# }