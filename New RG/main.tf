# Resource Group
# --------------

resource "azurerm_resource_group" "RG_Group4_week3_20220321" {
  name     = "RG_Group4_week3_20220321"
  location = var.location
  tags = var.tags
}


# App Service Plan
# --------------
resource "azurerm_app_service_plan" "Plan_Group4" {
  name                = "Group4-week3-apps-plan"
  location            = azurerm_resource_group.RG_Group4_week3_20220321.location
  resource_group_name = azurerm_resource_group.RG_Group4_week3_20220321.name
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
  location                = azurerm_resource_group.RG_Group4_week3_20220321.location
  resource_group_name     = azurerm_resource_group.RG_Group4_week3_20220321.name
  app_service_plan_id     = azurerm_app_service_plan.Plan_Group4.id
  #https_only              = true
  #client_affinity_enabled = false
  tags                		= var.tags

 # site_config {
      
        #     + site_config {
        #   + always_on                   = (known after apply)
        #   + app_command_line            = (known after apply)
        #   + auto_swap_slot_name         = (known after apply)
        #   + default_documents           = (known after apply)
        #   + dotnet_framework_version    = (known after apply)
        #   + ftps_state                  = (known after apply)
        #   + health_check_path           = (known after apply)
        #   + http2_enabled               = (known after apply)
        #   + ip_restriction              = (known after apply)
        #   + java_container              = (known after apply)
        #   + java_container_version      = (known after apply)
        #   + java_version                = (known after apply)
        #   + linux_fx_version            = (known after apply)
        #   + local_mysql_enabled         = (known after apply)
        #   + managed_pipeline_mode       = (known after apply)
        #   + min_tls_version             = (known after apply)
        #   + number_of_workers           = (known after apply)
        #   + php_version                 = (known after apply)
        #   + python_version              = (known after apply)
        #   + remote_debugging_enabled    = (known after apply)
        #   + remote_debugging_version    = (known after apply)
        #   + scm_ip_restriction          = (known after apply)
        #   + scm_type                    = (known after apply)
        #   + scm_use_main_ip_restriction = (known after apply)
        #   + use_32_bit_worker_process   = (known after apply)
        #   + websockets_enabled          = (known after apply)
        #   + windows_fx_version          = (known after apply)

        #   + cors {
        #       + allowed_origins     = (known after apply)
        #       + support_credentials = (known after apply)
        #     }
        # }
     
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