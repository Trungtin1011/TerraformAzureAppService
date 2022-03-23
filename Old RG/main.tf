# Resource Group
# --------------

resource "azurerm_resource_group" "RG_GROUP04_ACADEMY_20220316" {
  name     = "RG_GROUP04_ACADEMY_20220316"
  location = var.location
  tags = var.tags
}

#App Service Plan
#--------------
resource "azurerm_app_service_plan" "Plan_Group4" {
  name                = "Group4-week3-apps-plan"
  location            = azurerm_resource_group.RG_GROUP04_ACADEMY_20220316.location
  resource_group_name = azurerm_resource_group.RG_GROUP04_ACADEMY_20220316.name
  tags                = var.tags
  kind                = "Linux"
  reserved            = true # must be true for Linux

  sku {
    tier = "Basic"
    size = "B2"
  }
}


# App Service 
# --------------
resource "azurerm_app_service" "App_Group4" {
  name                    = "Group4-week3-app"
  location                = azurerm_resource_group.RG_GROUP04_ACADEMY_20220316.location
  resource_group_name     = azurerm_resource_group.RG_GROUP04_ACADEMY_20220316.name
  app_service_plan_id     = azurerm_app_service_plan.Plan_Group4.id
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